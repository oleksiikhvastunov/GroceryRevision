********************************************************************************
* This do file contains code which cleans the data and prepares it for input 
* for the 2_Matlab_Structures.do 
********************************************************************************

* This subsection takes data on the grocery stores for 10 years, removes all data
* except 2006 and creates 11 digit census tract code and 5 digit zip code
* (it is done because some of the stores have 9 digit zip-code and 12 digit census
* tract code
* storepanel.dta does not have information on the Club stores which will be processed 
* in the different subsection   

clear
use "storepanel.dta"
drop censusid
gen savealot=(storname=="Save A Lot")
* create 5 digit zipcode from 9 digit
gen zip5=floor(zipcode/10000)
* generate string censis id from numeric
tostring censusN, gen(censusid) format(%17.0g)
gen censusid11=substr(censusid,1,11)
* keep only stores for 2006
keep if period==13
save "stores06_zip5.dta", replace

********************************************************************************

* This subsection creates a name which would be used for tracking chain identity
* It is based on the parname - which is name of the parent company with some minor
* modifications 
clear

use "stores06_zip5.dta", clear
gen newParname=parname
replace newParname="Save A Lot" if savealot==1
replace newParname="Fred Meyer Stores Inc" if parname=="Kroger Co/HQ" & ownname=="Fred Meyer Stores Inc"
replace newParname="Save A Lot" if parname=="SuperValu Inc/HQ" & storname=="Save A Lot"
replace newParname="Hannaford Bros Co" if parname=="Delhaize America Inc" & ownname=="Hannaford Bros Co"
replace newParname="Giant Food" if parname=="Ahold USA Inc" & (ownname=="Giant Food Inc" | ownname=="Giant Food Stores Inc/HQ") 
replace newParname="Stop & Shop" if parname=="Ahold USA Inc" & newParname!="Giant Food" 
replace storname=newParname if newParname!="Independent"
save "stores06_zip5_parname.dta", replace

********************************************************************************

* This subsection creates mapping between msa codes and county code

clear
use "stores06_zip5_parname.dta"
keep msacode censusid11
gen countyid=substr(censusid11,1,5)
drop if length(countyid)~=5
drop if msacode==9999
drop censusid11 
duplicates drop
duplicates drop countyid, force
rename msacode msacode2
save "MSA_countyMAP.dta", replace


********************************************************************************

* This subsection creates id of the chain (for chains that have more than 100 stores)
* and removes stores which are in New York and not in MSA
clear


use "stores06_zip5_parname.dta"
* add local variable which would be used to put grid on the latitude and longtitude
local threshold=.5
local thr2=`threshold'/5

* remove New York msa
drop if msacode==5602
* remove stores that are not in MSA
drop if msacode==9999
by storname, sort: gen num_stores_chain=_N
sort num_stores_chain
sort format
egen id_format=group(format) 
* Hannaford has 108 stores in MSA so we need 100 stores threshold
* create id of the chain for large chains
sort storname
egen id_chain=group(storname) if num_stores_chain>100
* create chain id for medium chains
replace id_chain=0 if num_stores_chain<101 & num_stores_chain>9
* create chain id for small chains
replace id_chain=-1 if num_stores_chain<10
replace id_chain=id_chain+2
* we needed grocery fromat to be first because in one of the specifications 
* formats are used. In this specification all format coefficients are identified 
* compared to fist one which is for convenience is chosen to be grocery 
gen id_formatnew=id_format
replace id_formatnew=1 if id_format==4
replace id_formatnew=4 if id_format==1
drop id_format
rename id_formatnew id_format
gen id=_n
keep id latitude longitude id_format volume storname size chk_sqft fte checkout id_chain
* putting grid on the latitude and longtitude of the store location
gen intptlatfix=round(latitude,`threshold')
gen intptlongfix=round(longitude,`threshold')
save "stores06_zip5_smallparnameformatForPaper.dta", replace

********************************************************************************

* This subsection contains code that identifies counties that belong to MSA's
* This information will be used to remove club stores that does not belong to MSA's
clear
use "msa_county.dta"
tab MetropolitanMicropolitanStatist
sort MetropolitanMicropolitanStatist
egen typeArea=group(MetropolitanMicropolitanStatist)
tab typeArea
* Keep only Metropolitan Statistical Areas
keep if typeArea==1
gen countyid=FIPSStateCode+FIPSCountyCode
keep countyid
save "msa_county_small.dta",replace

********************************************************************************

* This subsection creates county codes which belong to New York MSA
clear
use "msa_county.dta"
* Keep counties that belong to New York CSA (which is Metropolitan and Micropolitan Statistical Areas)
keep if CSACode=="408"
sort MetropolitanMicropolitanStatist
egen MetrCoded=group(MetropolitanMicropolitanStatist)
* Remove Micropolitan Statistical Areas in New York CSA
drop if MetrCoded==2
gen countyid=FIPSStateCode+FIPSCountyCode
keep countyid
save "NewYorkMSA5602counties.dta", replace

********************************************************************************

* This subsection removes club stores that does not belong to MSA or belong to 
* New York MSA and combines it with nonclubstores for 2006
clear
* Open Data with Club stores for 2006
use "club06wdates.dta"
gen countyid=substr(censusid,1,5)
* Keep only MSA counties
merge m:1 countyid using "msa_county_small.dta"
keep if _merge==3
drop _merge
* Remove New York MSA counties
merge m:1 countyid using "NewYorkMSA5602counties.dta"
keep if _merge==1
drop _merge
gen stornamenew=storname
replace storname=substr(stornamenew,1,6)
replace storname="BJs" if storname=="BJs Wh"
replace storname="Sams" if storname=="Sams C"
gen id=_n
* Newsize variable will capture size of club stores and size will capture size 
* of all other stores 
gen newsize=size
keep storname volume newsize latitude longitude id
sort storname
egen id_chain=group(storname)
save "ClubStores2006SmallPaper.dta", replace
append using "stores06_zip5_smallparnameformatForPaper.dta"
* Missing size mean that it is a club store and since we are using log(size) 
* we assign size=1 for club stores
replace size=1 if missing(size)==1
replace fte=1 if missing(fte)==1
replace checkout=1 if missing(checkout)==1
local threshold=.5
replace intptlatfix=round(latitude,`threshold') if missing(intptlatfix)==1
replace intptlongfix=round(longitude,`threshold') if missing(intptlongfix)==1
sum id_format, detail
replace id_format=r(max)+1 if missing(id_format)==1
replace chk_sqft=1 if missing(chk_sqft)==1
replace newsize=1 if missing(newsize)==1
sum id_chain, detail
count if size==1
sum id_format, detail
gen clubstores=id_format==r(max)
sum id_chain, detail
replace id_chain=id_chain+r(max) if clubstores==1
sum id, detail
replace id=id+r(max) if clubstores==1
save "stores06_clubForPaper.dta", replace

********************************************************************************

* This subsection creates id for the census tracts

clear
use "censusTracts2010wIncome.dta", clear
local threshold=.5
local thr2=`threshold'/5
* Create id for the census tracts
* census_id is 14 digit string which includes State code and it is transformed into 
* census_groudidwhich is number that starts with 1
sort census_id
egen census_groupid=group(census_id)

keep census_id census_groupid
save "censusTracts_id.dta", replace

clear
use "censusTracts2010wIncome.dta", clear
local threshold=.5
local thr2=`threshold'/5
drop _merge
merge 1:1 census_id using "censusTracts_id.dta"
drop if _merge!=3
drop _merge


keep census_id census_groupid intptlat intptlong
gen intptlatfix=round(intptlat,`threshold')
gen intptlongfix=round(intptlong,`threshold')
save "censusTracts2010wIncome_small.dta", replace

clear
use "censusTracts2010wIncome.dta", clear
local threshold=.5
local thr2=`threshold'/5
* Create id for the census tracts
* census_id is 14 digit string which includes State code and it is transformed into 
* census_groudidwhich is number that starts with 1
merge 1:1 census_id using "censusTracts_id.dta"
drop if _merge!=3
drop _merge
save "censusTracts2010wIncome_nomerge.dta", replace

