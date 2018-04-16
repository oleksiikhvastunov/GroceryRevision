********************************************************************************

* Find tracts where Wild Oats and Whole Foods compete by finding census tracts 
* where both chains are present in the choice set  

cd ../MatlabMain
clear
insheet using  "StataStructures2010MSAClubForPaper.csv"
gen Whole=(id_chain==33)
gen Wild=(id_chain==34)
egen TrWhole=sum(Whole), by (fixcensus_groupid)
egen TrWild=sum(Wild), by (fixcensus_groupid)
duplicates drop fixcensus_groupid, force
cd ../Tables
merge 1:1 fixcensus_groupid using "MSAClubHerfForPaper3Nests.dta"
drop if _merge!=3
drop _merge
gen Competition=(TrWhole>0)*(TrWild>0)
tab Competition
save "WholeWildCompetingTracts.dta", replace

* Add census id (10 digit number that includes state and county code) to the 
* results of Wild Oats and Whole Foods merge in terms of difference in 
* herfindahl index (when club stores are present)

clear
import delimited "HerfdifClubMSA2006ForPaperWholeFoodsWildOats3Nests.csv"
rename v1 fixcensus_groupid
rename v2 herf1Club
rename v3 herf2Club
rename v4 herfdifClub
rename v5 passTest
merge 1:1 fixcensus_groupid using "MSAClubTractsCorrespondenceForPaper.dta"
drop _merge 
save "MSAClubHerfForPaperWholeWild3Nests.dta", replace
clear

* Add census id (10 digit number that includes state and county code) to the 
* results of Wild Oats and Whole Foods merge in terms of difference in 
* herfindahl index (when club stores are not present)

clear
import delimited "HerfdifNoClubMSA2006ForPaperWholeFoodsWildOats3Nests.csv"
rename v1 fixcensus_groupid
rename v2 herf1NoClub
rename v3 herf2NoClub
rename v4 herfdifNoClub
drop v5
merge 1:1 fixcensus_groupid using "MSANoClubTractsCorrespondenceForPaper.dta"
drop _merge 
save "MSANoClubHerfForPaperWholeWild3Nests.dta", replace

gen HerfAfterNoClub=herf2NoClub*10000
gen HerfIncreaseNoClub=herfdifNoClub*10000
gen RCNoClub=(((HerfAfterNoClub>1500)*(HerfAfterNoClub<2500)*(HerfIncreaseNoClub>100)+(HerfAfterNoClub>2500)*(HerfIncreaseNoClub<200)*(HerfIncreaseNoClub>100))>0)
gen WCNoClub=(((HerfAfterNoClub>2500)*(HerfIncreaseNoClub>200))>0)
merge 1:1 census_id using "MSAClubHerfForPaperWholeWild3Nests.dta"
drop if _merge!=3
drop _merge
gen HerfAfterClub=herf2Club*10000
gen HerfIncreaseClub=herfdifClub*10000
gen RCClub=(((HerfAfterClub>1500)*(HerfAfterClub<2500)*(HerfIncreaseClub>100)+(HerfAfterClub>2500)*(HerfIncreaseClub<200)*(HerfIncreaseClub>100))>0)
gen WCClub=(((HerfAfterClub>2500)*(HerfIncreaseClub>200))>0)
merge 1:1 census_id using "WholeWildCompetingTracts.dta"
drop if _merge!=3
drop _merge

gen MergeResultClub=RCClub+2*WCClub
tab MergeResultClub
gen MergeResultNoClub=RCNoClub+2*WCNoClub
tab MergeResultNoClub
cd ../TablesOutput

keep if Competition==1

* Crosstab of merge results for Wild Oats and Whole Foods merge in the presence and absence of club stores

tabout MergeResultClub MergeResultNoClub using TableAppendixB1.tex, replace c(freq) style(tex)

********************************************************************************

* Characteristics of tracts with different merger evaluation results for Ahold 
* and Delhaize case

cd ../MatlabMain

clear
insheet using  "StataStructures2010MSAClubForPaper.csv"
gen Del=(id_chain==6)+(id_chain==12)
gen Ahold=(id_chain==9)+(id_chain==27)
egen TrDel=sum(Del), by (fixcensus_groupid)
egen TrAhold=sum(Ahold), by (fixcensus_groupid)
gen compStores=(TrDel+TrAhold)*(TrDel>0)*(TrAhold>0)
duplicates drop fixcensus_groupid, force
keep fixcensus_groupid pop10 logpcincome density hhsize compStores 
gen income=exp(logpcincome)
cd ../Tables
save "CompetingStoresTractCharacteristicsForPaper.dta",replace

clear
* Appendix table with hotspots tracts by state 
use "MSAClubHerfForPaper3Nests.dta"

merge 1:1 fixcensus_groupid using "CompetingStoresTractCharacteristicsForPaper.dta"
gen state=substr(census_id,1,2)
tab state if compStores>0
gen tractsType=0 if compStores>0
gen tractsComp=1 if compStores>0
gen tractsHS=passTest
tab passTest
egen compState=sum(compStores), by(state)
gen once=1
egen tractsState=sum(once), by(state)
replace income=income/1000
* table B.2
latabstat tractsState income hhsize density pop10 herf2Club herfdifClub compStores if compState>0, by(state) stat(mean) f(%12.2fc) 
egen numtractsComp=sum(once), by(state tractsComp)
latabstat numtractsComp income hhsize density pop10 herf2Club herfdifClub compStores if compState>0 & tractsComp==1, by(state) stat(mean) f(%12.2fc) 
egen violateMerge=sum(passTest), by (state)
latabstat violateMerge income hhsize density pop10 herf2Club herfdifClub compStores if compState>0 & tractsComp==1 & passTest==1, by(state) stat(mean) f(%12.2fc) 
gen compNonViol=(passTest==0)*(compStores>0)
egen nonviolateMerge=sum(compNonViol), by (state)
latabstat nonviolateMerge income hhsize density pop10 herf2Club herfdifClub compStores if compState>0 & tractsComp==1 & passTest==0, by(state) stat(mean) f(%12.2fc) 
