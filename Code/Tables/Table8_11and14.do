********************************************************************************

* Add census id (10 digit number that includes state and county code) to the 
* results of Ahold and Delhaize merge in terms of difference in herfindahl index

clear
import delimited "HerfdifClubMSA2006ForPaper3Nests.csv"
rename v1 fixcensus_groupid
rename v2 herf1Club
rename v3 herf2Club
rename v4 herfdifClub
rename v5 passTest
merge 1:1 fixcensus_groupid using "MSAClubTractsCorrespondenceForPaper.dta"
drop _merge 
save "MSAClubHerfForPaper3Nests.dta", replace

********************************************************************************

* Create summary statistics for the census tracts with different concentration index

clear
cd ../MatlabMain
insheet using  "StataStructures2010MSAClubForPaper.csv"
cd ../Tables
gen once=1
egen numStores=sum(once), by (fixcensus_groupid)
sum id_chain, detail
gen largeChain=(id_chain>2)*(id_chain<r(max)-2)
egen largeChainNumStores=sum(largeChain), by (fixcensus_groupid)
by fixcensus_groupid id_chain, sort: gen largeFirst=(_n==1)
gen largeFirstLarge=largeFirst*largeChain
egen LargeChainNum=sum(largeFirstLarge), by (fixcensus_groupid)
gen income=exp(logpcincome)/1000
sum income, detail
sum id_chain, detail
gen clubStores=(id_chain>r(max)-3)
egen clubStoresNum=sum(clubStores), by (fixcensus_groupid)
duplicates drop fixcensus_groupid, force
merge 1:1 fixcensus_groupid using "MSAClubHerfForPaper3Nests.dta"
drop if _merge!=3
drop _merge
gen Herf1Club=10000*herf1Club
gen Concentration=(Herf1Club>2500)+(Herf1Club>1500)+1
la def Concentration 1 "Low   x <=1500" 2 "Medium 1500 < x <= 2500" 3 "High   2500<x"
cd ../TablesOutput
* Table 8, 10 miles
save "Table8Data10miles.dta", replace
tabout Concentration using Table8Data10miles.txt, c(mean income mean density mean numStores mean largeChainNumStores  mean LargeChainNum mean clubStoresNum)  f(2) sum rep style(tex) 


clear
cd ../MatlabMain
insheet using  "StataStructures2010MSAClubForPaper.csv"
cd ../Tables
gen once=((distance_miles+newdistance_miles)<5)
egen numStores=sum(once), by (fixcensus_groupid)
sum id_chain, detail
gen largeChain=(id_chain>2)*(id_chain<r(max)-2)*((distance_miles+newdistance_miles)<5)
egen largeChainNumStores=sum(largeChain), by (fixcensus_groupid)
gen distanceBand=((newdistance_miles+distance_miles)<5)
by fixcensus_groupid id_chain distanceBand, sort: gen largeFirst=(_n==1)
replace largeFirst=largeFirst*distanceBand*largeChain
egen LargeChainNum=sum(largeFirst), by (fixcensus_groupid)
gen income=exp(logpcincome)/1000
sum id_chain, detail
gen clubStores=(id_chain>r(max)-3)*distanceBand
egen clubStoresNum=sum(clubStores), by (fixcensus_groupid)
duplicates drop fixcensus_groupid, force
merge 1:1 fixcensus_groupid using "MSAClubHerfForPaper3Nests.dta"
drop if _merge!=3
drop _merge
gen Herf1Club=10000*herf1Club
gen Concentration=(Herf1Club>2500)+(Herf1Club>1500)+1
la def Concentration 1 "Low   x <=1500" 2 "Medium 1500 < x <= 2500" 3 "High   2500<x"
* Table 8, 5 miles
cd ../TablesOutput
save "Table8Data5miles.dta", replace
tabout Concentration using Table8Data5miles.txt, c(mean income mean density mean numStores mean largeChainNumStores  mean LargeChainNum mean clubStoresNum)  f(2) sum rep style(tex) 
cd ../Tables

********************************************************************************

* Add census id (10 digit number that includes state and county code) to the 
* results of Wild Oats and Whole Foods merge in terms of difference in 
* herfindahl index 

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

* Find tracts where Wild Oats and Whole Foods compete by finding census tracts 
* where both chains are present in the choice set  

clear
cd ../MatlabMain
insheet using  "StataStructures2010MSAClubForPaper.csv"
gen Whole=(id_chain==33)
gen Wild=(id_chain==34)
egen TrWhole=sum(Whole), by (fixcensus_groupid)
egen TrWild=sum(Wild), by (fixcensus_groupid)
duplicates drop fixcensus_groupid, force
cd ../Tables
merge 1:1 fixcensus_groupid using "MSAClubHerfForPaperWholeWild3Nests.dta"
drop if _merge!=3
drop _merge
gen Competition=(TrWhole>0)*(TrWild>0)
tab Competition
gen HerfAfter=herf2Club*10000
gen HerfIncrease=herfdifClub*10000
* Actually it is Warrants Scrunity
gen RC=(((HerfAfter>1500)*(HerfAfter<2500)*(HerfIncrease>100)+(HerfAfter>2500)*(HerfIncrease<200)*(HerfIncrease>100))>0)
* It is Enhance Market Power
gen WC=(((HerfAfter>2500)*(HerfIncrease>200))>0)
gen popComp=pop10*Competition
gen popRC=pop10*RC
gen popWC=pop10*WC
gen State=substr(census_id,1,2)
gen once=1
egen StateGR=group(State)
egen popRCState=sum(popRC), by (State)
egen popWCState=sum(popWC), by (State)
egen popCompState=sum(popComp), by (State)
replace popCompState=popCompState/1000
replace popRCState=popRCState/1000
replace popWCState=popWCState/1000
egen RCTrByState=sum(RC), by (State)
egen WCTrByState=sum(WC), by (State)
egen CompTrByState=sum(Competition), by (State)
drop if CompTrByState==0
replace popComp=popComp/1000
replace popRC=popRC/1000
replace popWC=popWC/1000
pwd


rename WCTrByState EMPTrByState
rename popWCState popEMPState
rename RCTrByState WCTrByState
rename popRCState popWCState
rename WC EMP
rename popWC popEMP
rename popRC popWC
rename RC WC
cd ../TablesOutput
* Table 9 total
tabout once using Table9Total.tex, c(sum Competition    sum popComp sum WC sum popWC sum EMP sum popEMP)  f(2) sum rep style(tex) oneway
* Table 9 by state
tabout State using Table9.tex, c(mean CompTrByState     mean popCompState mean WCTrByState mean popWCState mean EMPTrByState mean popEMPState)  f(2) sum rep style(tex) oneway
cd ../Tables

********************************************************************************

* Find tracts where Ahold and Delhaize compete by finding census tracts 
* where both chains are present in the choice set  


clear
cd ../MatlabMain
insheet using  "StataStructures2010MSAClubForPaper.csv"
cd ../Tables
gen Del=(id_chain==6)+(id_chain==12)
gen Ahold=(id_chain==9)+(id_chain==27)
egen TrDel=sum(Del), by (fixcensus_groupid)
egen TrAhold=sum(Ahold), by (fixcensus_groupid)
duplicates drop fixcensus_groupid, force
merge 1:1 fixcensus_groupid using "MSAClubHerfForPaper3Nests.dta"
drop if _merge!=3
drop _merge
gen Competition=(TrDel>0)*(TrAhold>0)
gen HerfAfter=herf2Club*10000
gen HerfIncrease=herfdifClub*10000

* Actually it is Warrants Scrunity
gen RC=(((HerfAfter>1500)*(HerfAfter<2500)*(HerfIncrease>100)+(HerfAfter>2500)*(HerfIncrease<200)*(HerfIncrease>100))>0)

* It is Enhance Market Power
gen WC=(((HerfAfter>2500)*(HerfIncrease>200))>0)
gen popComp=pop10*Competition
gen popRC=pop10*RC
gen popWC=pop10*WC
gen State=substr(census_id,1,2)
gen once=1
egen StateGR=group(State)
egen popRCState=sum(popRC), by (State)
egen popWCState=sum(popWC), by (State)
egen popCompState=sum(popComp), by (State)
replace popCompState=popCompState/1000
replace popRCState=popRCState/1000
replace popWCState=popWCState/1000
egen RCTrByState=sum(RC), by (State)
egen WCTrByState=sum(WC), by (State)
egen CompTrByState=sum(Competition), by (State)
drop if CompTrByState==0
replace popComp=popComp/1000
replace popRC=popRC/1000
replace popWC=popWC/1000

rename WCTrByState EMPTrByState
rename popWCState popEMPState
rename RCTrByState WCTrByState
rename popRCState popWCState
rename WC EMP
rename popWC popEMP
rename popRC popWC
rename RC WC
cd ../TablesOutput
* Table 10 by state
tabout State using Table10Data.tex, c(mean CompTrByState     mean popCompState mean WCTrByState mean popWCState mean EMPTrByState mean popEMPState)  f(2) sum rep style(tex) oneway

cd ../Tables
* Table 10, total
tabout once using Table10Total.tex, c(sum Competition    sum popComp sum WC sum popWC sum EMP sum popEMP)  f(2) sum rep style(tex) oneway

save "TwoTypesOfMergeConclusion3Nests.dta", replace

********************************************************************************

* Crosstab of population density and merger evaluation for Ahold and Delhaize 
* merge   


clear
cd ../MatlabMain
insheet using  "StataStructures2010MSAClubForPaper.csv"
cd ../Tables
gen Del=(id_chain==6)+(id_chain==12)
gen Ahold=(id_chain==9)+(id_chain==27)
egen TrDel=sum(Del), by (fixcensus_groupid)
egen TrAhold=sum(Ahold), by (fixcensus_groupid)
duplicates drop fixcensus_groupid, force
merge 1:1 fixcensus_groupid using "MSAClubHerfForPaper3Nests.dta"
drop if _merge!=3
drop _merge
gen Competition=(TrDel>0)*(TrAhold>0)
gen HerfAfter=herf2Club*10000
gen HerfIncrease=herfdifClub*10000
sum density, detail
* Actually it is Warrants Scrunity
gen RC=(((HerfAfter>1500)*(HerfAfter<2500)*(HerfIncrease>100)+(HerfAfter>2500)*(HerfIncrease<200)*(HerfIncrease>100))>0)
* It is Enhance Market Power
gen WC=(((HerfAfter>2500)*(HerfIncrease>200))>0)
tab Competition RC
tab Competition WC
sum density, detail
drop if Competition==0
sum density, detail
gen Type=1+RC+2*WC
tab Type

gen once=1

gen densitytype=(density>4000)+(density>1500)+1
cd ../TablesOutput
* Table 11
tabout densitytype Type using Table11.tex, c(sum once)  f(2) sum rep style(tex) 
cd ../Tables

********************************************************************************

clear
cd ../Stata
use "censusTracts2010wIncome_nomerge.dta"
keep census_id census_groupid 
merge 1:m census_groupid using "fix_store_tract_idsclubForPaper.dta"
drop if _merge!=3
drop _merge
keep census_id census_groupid fixcensus_groupid 
duplicates drop
merge 1:m fixcensus_groupid using "ForPaperClubvsNoClubStoresAndTractsMapping.dta"
drop if _merge!=3
duplicates drop census_id census_groupid fixcensus_groupid groupfixcensus_groupid, force
drop fixid groupfixid _merge 
replace fixcensus_groupid=groupfixcensus_groupid
drop groupfixcensus_groupid
cd ../Tables
save "MSANoClubTractsCorrespondenceForPaper.dta", replace

* Add census id (10 digit number that includes state and county code) to the 
* results of Ahold and Delhaize merge in terms of difference in herfindahl index
* for the case when club stores are not present. In order to do that 
* correspondence (saved in "MSANoClubTractsCorrespondenceForPaper.dta") between 10 digit census id and tract id that starts with 1 and 
* uses consequential number is used

clear
import delimited "HerfdifNoClubMSA2006ForPaper3Nests.csv"
rename v1 fixcensus_groupid
rename v2 herf1NoClub
rename v3 herf2NoClub
rename v4 herfdifNoClub
drop v5
merge 1:1 fixcensus_groupid using "MSANoClubTractsCorrespondenceForPaper.dta"
drop _merge 
save "MSANoClubHerfForPaper3Nests.dta", replace

gen HerfAfterNoClub=herf2NoClub*10000
gen HerfIncreaseNoClub=herfdifNoClub*10000
gen RCNoClub=(((HerfAfterNoClub>1500)*(HerfAfterNoClub<2500)*(HerfIncreaseNoClub>100)+(HerfAfterNoClub>2500)*(HerfIncreaseNoClub<200)*(HerfIncreaseNoClub>100))>0)
gen WCNoClub=(((HerfAfterNoClub>2500)*(HerfIncreaseNoClub>200))>0)

merge 1:1 census_id using "MSAClubTractsCorrespondenceForPaper.dta"
drop if _merge!=3
drop _merge

merge 1:1 census_id using "TwoTypesOfMergeConclusion3Nests.dta"
drop if _merge!=3
drop _merge

gen HerfAfterClub=herf2Club*10000
gen HerfIncreaseClub=herfdifClub*10000
gen RCClub=(((HerfAfterClub>1500)*(HerfAfterClub<2500)*(HerfIncreaseClub>100)+(HerfAfterClub>2500)*(HerfIncreaseClub<200)*(HerfIncreaseClub>100))>0)
gen WCClub=(((HerfAfterClub>2500)*(HerfIncreaseClub>200))>0)

gen MergeResult=RCClub+2*WCClub
gen MergeResultNoClub=RCNoClub+2*WCNoClub

keep if Competition==1

cd ../TablesOutput
la def MergeResult 0 "Compete" 1 "Warrants Scrunity" 2 "Enhance Market Power"
tabout MergeResult MergeResultNoClub using Table14.tex, replace c(freq) style(tex)
cd ../Tables


