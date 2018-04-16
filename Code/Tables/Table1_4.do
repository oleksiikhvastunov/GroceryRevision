********************************************************************************

* In this subsection summary statistics for the stores which belong to small, medium or large chains are created

clear
cd ../Stata
use "club06wdates.dta"
gen countyid=substr(censusid,1,5)
merge m:1 countyid using "msa_county_small.dta"
keep if _merge==3
drop _merge
merge m:1 countyid using "NewYorkMSA5602counties.dta"
keep if _merge==1
drop _merge
append using "stores06_zip5_parname.dta"

keep if missing(msacode)==1 | (msacode!=5602)


gen clubstores=1 if missing(msacode)==1
replace clubstores=0 if missing(msacode)==0
replace storname=substr(storname,1,6) if clubstores==1
replace storname="BJs" if storname=="BJs Wh"
replace storname="Sams" if storname=="Sams C"

gen once=1
egen stperchain=sum(once), by (storname)
distinct storname if stperchain>110

gen large=(stperchain>100)
gen medium=(stperchain<101) & (stperchain>9)
gen small=(stperchain<10)





keep if missing(msacode)==1 | (msacode!=5602 & msacode!=9999)

merge 1:1 latitude longitude volume size using "stores06_clubForPaper.dta"
drop if _merge==2
drop _merge
gen supercenter=((id_chain==17) | (id_chain==29) | (id_chain==31))


egen stperchainmsa=sum(once), by (storname)
sum stperchainmsa if large==1, detail
tab storname if large==1 & stperchainmsa<100



replace fte=log(0) if clubstores==1
replace checkout=log(0) if clubstores==1 
gen largemsa=(stperchainmsa>100)
gen mediummsa=(stperchainmsa<101) & (stperchainmsa>9)
gen smallmsa=(stperchainmsa<10)

count if mediummsa==1
gen mediumpercent=3776/24117
count if smallmsa==1
gen smallpercent=6055/24117




quietly tabstat size volume fte checkout, c(s) stat(mean sd p25 p50 p75) save
matrix output=r(StatTotal)'
cd ../Tables
cd ../TablesOutput
* summary statistics for all stores is created
outtable using tabledata11, mat(output) center replace caption("Data.1.1 Store Characteristics") nobox f(%12.2fc) label

quietly tabstat size volume fte checkout if mediummsa==1 | smallmsa==1, c(s) stat(mean sd p25 p50 p75) save
matrix output=r(StatTotal)'
* summary statistics for small and medium chains is created
outtable using tabledata12, mat(output) center replace caption("Data.1.2 Store Characteristics") nobox f(%12.2fc) label

quietly tabstat size volume fte checkout if largemsa==1 & supercenter==0 & clubstores==0, c(s) stat(mean sd p25 p50 p75) save
matrix output=r(StatTotal)'
* summary statistics for large chains which are not supercenters or clubstores is created
outtable using tabledata13, mat(output) center replace caption("Data.1.3 Store Characteristics") nobox f(%12.2fc) label


quietly tabstat size volume fte checkout if largemsa==1 & supercenter==1 & clubstores==0, c(s) stat(mean sd p25 p50 p75) save
matrix output=r(StatTotal)'
* summary statistics for supercenter stores is created
outtable using tabledata135, mat(output) center replace caption("Data.1.35 Store Characteristics") nobox f(%12.2fc) label


quietly tabstat size volume fte checkout if largemsa==1 & clubstores==1, c(s) stat(mean sd p25 p50 p75) save
matrix output=r(StatTotal)'
* summary statistics for clubstores is created
outtable using tabledata14, mat(output) center replace caption("Data.1.4 Store Characteristics") nobox f(%12.2fc) label

save "Table1Data.dta", replace


********************************************************************************

* Chain charasteristics are created

cd ../Tables
cd ../Stata
merge 1:1 latitude longitude volume using "stores06_clubForPaper.dta"
drop if _merge!=3
drop _merge

merge m:1 countyid using "MSA_countyMAP.dta"
replace msacode=msacode2 if missing(msacode)==1
count if missing(msacode)==1

replace msacode=9999 if missing(msacode)==1
egen nSt=sum(once), by (storname)
drop if nSt==1
egen revPStore=mean(volume), by (storname)
egen sizePStore=mean(size), by (storname)
gen rev_sqft=volume/size
egen revsizePStore=mean(rev_sqft), by (storname)
cd ../Tables
save "ForTable2and3.dta", replace
duplicates drop msacode storname, force
egen msaPStore=sum(once),  by (storname)
sum msaPStore, detail
duplicates drop storname, force
egen msaPChain=mean(msaPStore), by(storname)
cd ../TablesOutput
save "Table2Data.dta", replace

quietly tabstat nSt revPStore sizePStore revsizePStore msaPChain if smallmsa==0, c(s) stat(mean sd p25 p50 p75) save
matrix output=r(StatTotal)'
* number of stores per chain and number of msa per chain is created for all chains but small
outtable using tabledata2, mat(output) center replace caption("Data.2 Chain Characteristics") nobox f(%12.2fc) label


quietly tabstat nSt revPStore sizePStore revsizePStore msaPChain if mediummsa==1, c(s) stat(mean sd p25 p50 p75) save
matrix output=r(StatTotal)'
* number of stores per chain and number of msa per chain is created for medium chains
outtable using tabledata21, mat(output) center replace caption("Data.21 Chain Characteristics") nobox f(%12.2fc) label

quietly tabstat nSt revPStore sizePStore revsizePStore msaPChain if largemsa==1 & supercenter==0 & clubstores==0, c(s) stat(mean sd p25 p50 p75) save
matrix output=r(StatTotal)'
* number of stores per chain and number of msa per chain is created for large nonsupercenter and clubstores chains
outtable using tabledata22, mat(output) center replace caption("Data.22 Chain Characteristics") nobox f(%12.2fc) label

quietly tabstat nSt revPStore sizePStore revsizePStore msaPChain if largemsa==1 & supercenter==1 & clubstores==0, c(s) stat(mean sd p25 p50 p75) save
matrix output=r(StatTotal)'
* number of stores per chain and number of msa per chain is created for supercenter chains
outtable using tabledata225, mat(output) center replace caption("Data.225 Chain Characteristics") nobox f(%12.2fc) label


quietly tabstat nSt revPStore sizePStore revsizePStore msaPChain if largemsa==1 & clubstores==1, c(s) stat(mean sd p25 p50 p75) save
matrix output=r(StatTotal)'
* number of stores per chain and number of msa per chain is created for club chains
outtable using tabledata23, mat(output) center replace caption("Data.23 Chain Characteristics") nobox f(%12.2fc) label

********************************************************************************

* Create summary statistics for each large chain

cd ../Tables
cd ../TablesOutput
clear
use "ForTable2and3.dta"
keep if largemsa==1
egen storePerMSA=sum(once), by (msacode storname)

duplicates drop msacode storname, force
egen storePerMSAmean=mean(storePerMSA), by (storname)
egen msaPStore=sum(once),  by (storname)
* Data.3 Large Chains Characteristics
save "Table3Data.dta", replace
* Table that produces each large chain summary statistics
latabstat nSt msaPStore storePerMSAmean revPStore revsizePStore sizePStore, by(storname) stat(mean) f(%12.2fc)
cd ../Tables

********************************************************************************

* Demographic and retail environment for the census tracts 

clear
cd ../MatlabMain
import delimited StataStructures2010MSAClubForPaper.csv
distinct fixcensus_groupid
cd ../Tables
merge m:1 fixcensus_groupid using "MSAClubTractsCorrespondenceForPaper.dta"
drop if _merge!=3
drop _merge
gen less5=((distance_miles+newdistance_miles)<5)
gen less10=((distance_miles+newdistance_miles)<10)
count if less10==1
gen lsless5=((distance_miles+newdistance_miles)<5)*(id_chain>2)*(id_chain<36)
gen lsless10=((distance_miles+newdistance_miles)<10)*(id_chain>2)*(id_chain<36)
gen clless5=((distance_miles+newdistance_miles)<5)*(id_chain>35)
gen clless10=((distance_miles+newdistance_miles)<10)*(id_chain>35)
egen stless5=sum(less5), by(fixcensus_groupid)
egen stless10=sum(less10), by(fixcensus_groupid)
egen stlsless5=sum(lsless5), by(fixcensus_groupid)
egen stlsless10=sum(lsless10), by(fixcensus_groupid)
egen stclless5=sum(clless5), by(fixcensus_groupid)
egen stclless10=sum(clless10), by(fixcensus_groupid)
duplicates drop fixcensus_groupid, force
gen countyid=substr(census_id,3,5)
label variable pop10 `"Population"'
gen income=exp(logpcincome)/1000
label variable income `"Average income"'
label variable density `"Population Density"'
label variable hhsize `"Household size"'
label variable stless5 `"Stores within 5 miles"'
label variable stless10 `"Stores within 10 miles"'
label variable stlsless5 `"Large chain within 5 miles"'
label variable stlsless10 `"Large chain within 10 miles"'
label variable stclless5 `"Club stores within 5 miles"'
label variable stclless10 `"Club stores within 10 miles"'
cd ../TablesOutput
save "Table4Data.dta", replace
quietly tabstat pop10 income density hhsize stless5 stless10 stlsless5 stlsless10 stclless5 stclless10, c(s) stat(mean sd p25 p50 p75) save
matrix output=r(StatTotal)'
* Table that creates demographics and retail environment summary for the census tracts
outtable using tabledata4, mat(output) center replace caption("Data.4 Census tracts population and income") nobox f(%12.2fc) label
