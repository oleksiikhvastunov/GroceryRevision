********************************************************************************
* This do file takes data files created by 1_Data_Cleaning.do and creates 
* structures used by Matlab
********************************************************************************

* This subsection matches stores to tracts and it is done by creating a grid 
* which is governed by parameter thr2, and then stores and tracts are matched 
* using this grid

clear
* in order to match store and tract, we first need to identify tracts that are close to the store. In order to do that we devide country into rectangles according to the lattitude and nongtitude
* threshold defines size of the rectangle
* we match tracts to a store within rectangle and also to tracts that belong to the close rectangles (if we are close to the corner we include all three rectangles that are consecutive to the corner)
* having identified close tracts we choose one that is the closest to the store 
* Creating all store tract pairs as the first step to uncovering close tract-tract pairs
* is memomy infeasible, so we need to create to create tract-tract pairs that are close
* enough (belong to ajacent rectangulas)
* This is done by creating at the fist step list of tracts where each tract is 
* present 4 times as a member of its own rectangle and to the west, south and southwest
* Later on pairwise combinations would be created within rectangle and duplicates will be removed 
use "censusTracts2010wIncome_small.dta"
local threshold=.5
local thr2=`threshold'/5
* Assign census tract to the south of it's actual rectangle
gen help=intptlat-`thr2'*sign(intptlatfix-intptlat)
replace intptlatfix=round(help,`threshold')
drop help
append using "censusTracts2010wIncome_small.dta"
save "censusTracts2010wIncome_small_all.dta",replace
clear
use "censusTracts2010wIncome_small.dta"
* Assign census tract to the west of it's actual rectangle
gen help=intptlong-`thr2'*sign(intptlongfix-intptlong)
replace intptlongfix=round(help,`threshold')
drop help
append using "censusTracts2010wIncome_small_all.dta"
save "censusTracts2010wIncome_small_all.dta",replace
clear
use "censusTracts2010wIncome_small.dta"
* Assign census tract to the southwest of it's actula rectangle
gen help=intptlat-`thr2'*sign(intptlatfix-intptlat)
gen help2=intptlong-`thr2'*sign(intptlongfix-intptlong)
replace intptlatfix=round(help,`threshold')
replace intptlongfix=round(help2,`threshold')
drop help help2
append using "censusTracts2010wIncome_small_all.dta"
duplicates drop
save "censusTracts2010wIncome_small_all.dta",replace



clear
use "censusTracts2010wIncome_small_all.dta"
* Matching stores to tracts using grid rectangles
joinby intptlatfix intptlongfix using "stores06_clubForPaper.dta", unmatched(none)
gen central_angle=2*asin((sin(_pi*(intptlat-latitude)/(2*180))*sin(_pi*(intptlat-latitude)/(2*180))+cos(_pi*intptlat/180)*cos(_pi*latitude/180)*sin(_pi*(intptlong-longitude)/(2*180))*sin(_pi*(intptlong-longitude)/(2*180)))^0.5)
* Creating distance in miles (3959 is radius of earth in miles)
gen distance_miles=3959*central_angle
sort id distance_miles
by id: gen withinidobs=_n
* Keep only census tract which is closest to the store
drop if withinidobs!=1
save "matched_clubstores_to2010tractsForPaper.dta", replace

********************************************************************************

* This subsection creates pairs of census tracts which are within 15 miles from 
* each other (based on the centroids)
clear
use "censusTracts2010wIncome_small_all.dta"
renpfix "" new
rename newintptlatfix intptlatfix
rename newintptlongfix intptlongfix
* Create pairwise combinations of census tracts within grid rectangles
joinby intptlatfix intptlongfix using "censusTracts2010wIncome_small_all.dta", unmatched(none)
gen central_angle=2*asin((sin(_pi*(intptlat-newintptlat)/(2*180))*sin(_pi*(intptlat-newintptlat)/(2*180))+cos(_pi*intptlat/180)*cos(_pi*newintptlat/180)*sin(_pi*(intptlong-newintptlong)/(2*180))*sin(_pi*(intptlong-newintptlong)/(2*180)))^0.5)
* Create distance between centroids of the census tracts
gen distance_miles=3959*central_angle
sort census_id distance_miles
* Remove pairs of census tracts whose centroids are more than 15 miles apart
drop if distance_miles>15
duplicates drop census_id newcensus_id, force
drop census_id newcensus_id
save "close_tracts_2010_pairs.dta",replace

* In this section we keep only pairs of census tracts which are within 5 miles from each other
* This information will be used to construct density within 5 mile radius from census tract

clear
use "close_tracts_2010_pairs.dta"
keep distance_miles newcensus_groupid census_groupid
drop if distance>5
save "close_tracts_2010_pairs_small.dta",replace

********************************************************************************

* This subsection creates structures that are used in Matlab
* The structure contains store-tract pairs and each row in the stucture also 
* contains characteristics of store and tract in question
* It is done this way in order to calculate utilities of the stores as simple
* matrix multiplication

clear
use "close_tracts_2010_pairs.dta"
rename census_groupid centercensus_groupid
rename newcensus_groupid census_groupid
* Tract-tract stucture is combined with stores to obtain Store-tract structure
joinby census_groupid using "matched_clubstores_to2010tractsForPaper.dta", unmatched(none)
gen central_angleactual=2*asin((sin(_pi*(intptlat-latitude)/(2*180))*sin(_pi*(intptlat-latitude)/(2*180))+cos(_pi*intptlat/180)*cos(_pi*latitude/180)*sin(_pi*(intptlong-longitude)/(2*180))*sin(_pi*(intptlong-longitude)/(2*180)))^0.5)
gen distanseactual=3959*central_angleactual
drop distance_miles
rename distanseactual distance_miles
keep census_groupid centercensus_groupid distance_miles id id_format volume size chk_sqft fte checkout id_chain newsize
rename census_groupid storecensus_groupid
rename centercensus_groupid  census_groupid
* The relevant radius of the choice set was set up 10 miles 
* We have done robustness checks for the radius and results did not change much
drop if distance_miles>10
merge m:1 census_groupid using "censusTracts2010wIncome_nomerge.dta"
drop if _merge!=3
drop if pop10==0
drop if missing(pcIncome)==1
gen density=pop10/aland_sqmi
* In the dataset 2010 mean and median are confused. Rename fix this problem
drop hh_inc_med
rename hh_inc_mean hh_inc_med 
gen hhIncome=real(hh_inc_med)
drop if missing(hhIncome)==1
replace hhIncome=min(hhIncome, 200001*(218.056/172.2))
gen hhsize=pop10/hu10
drop if hhsize>10
gen logfte=log(fte)
gen logchkt=log(checkout)

keep census_groupid storecensus_groupid distance_miles id_format id pop10 pcIncome volume size chk_sqft density hhsize logfte logchkt id_chain newsize 
sort census_groupid storecensus_groupid
keep census_groupid distance_miles id_format id pop10 pcIncome volume size chk_sqft density hhsize logfte logchkt id_chain newsize 
* After we decided to concentrate on MSA's some of the census tracts and stores are no longer 
* part of the analysis
* For Matlab we need all the the census id's and store id's to start from 1 and 
* be consecutive with no gaps, so we need to do group command again
egen fixcensus_groupid=group(census_groupid)
egen fixid=group(id)
preserve
drop census_groupid
drop id
order fixcensus_groupid distance_miles volume id_format fixid pop10 pcIncome size chk_sqft density hhsize logfte logchkt id_chain newsize, first
restore
preserve
keep fixcensus_groupid census_groupid fixid id
save "fix_store_tract_idsclubForPaper.dta", replace
restore
drop census_groupid
drop id
order fixcensus_groupid distance_miles volume id_format fixid pop10 pcIncome size chk_sqft density hhsize logfte logchkt id_chain newsize, first
rename pcIncome logpcIncome
replace logpcIncome=log(logpcIncome)
egen meanlogpcIncome=mean(logpcIncome)
gen logpcIncomeDeMean=logpcIncome-meanlogpcIncome
drop meanlogpcIncome
outsheet using  "StataStructures2010MSAClubForPaper.csv", replace comma

********************************************************************************

* This subsection creates density within 5 mile radius from the centroid of 
* census tract and updates Matlab structures. Density is used to parametrize 
* outside option in the demand estimation  

clear
use "censusTracts2010wIncome_nomerge.dta"
gen density=pop10/aland_sqmi
keep census_groupid pop10 aland_sqmi
merge 1:m census_groupid using "close_tracts_2010_pairs_small.dta"
drop _merge
rename pop10 oldpop10
rename aland_sqmi oldaland_sqmi
rename census_groupid oldcensus_groupid
rename newcensus_groupid census_groupid
* Calculate density in 5 mile radius
egen poparound=sum(oldpop10), by (census_groupid)
egen areaaround=sum(oldaland_sqmi), by (census_groupid)
gen densityaround=poparound/areaaround
keep if (oldcensus_groupid==census_groupid)
gen density=oldpop10/oldaland_sqmi

keep census_groupid densityaround
merge 1:m census_groupid using "fix_store_tract_idsclubForPaper.dta"
drop if _merge!=3
duplicates drop fixcensus_groupid, force
drop census_groupid id fixid _merge 
save "censusTracts_density5milesclubForPaper.dta", replace
clear

* Add density within 5 mile radius to the Matlab Structures

insheet using  "StataStructures2010MSAClubForPaper.csv"
merge m:1 fixcensus_groupid using "censusTracts_density5milesclubForPaper.dta"
drop _merge
replace density=densityaround
drop densityaround 
gen clubsize=newsize
drop newsize
sum id_format, detail
gen club=(id_format==r(max))
gen newdistance_miles=distance_miles*club
replace distance_miles=(distance_miles*(1-club))
drop club 
sort fixcensus_groupid fixid
cd ../MatlabMain
outsheet using  "StataStructures2010MSAClubForPaper.csv", replace comma
cd ../Stata

* Remove club stores in order to be able to draw results of merges in the case 
* when we neglect club stores 
drop if id_format==6
egen groupfixcensus_groupid=group(fixcensus_groupid)
egen groupfixid=group(fixid)
preserve
keep fixcensus_groupid fixid groupfixcensus_groupid groupfixid
save "ForPaperClubvsNoClubStoresAndTractsMapping.dta",replace
restore
* Create Matlab structure for the case when we don't take club stores into account
replace fixcensus_groupid=groupfixcensus_groupid
replace fixid=groupfixid
drop clubsize newdistance_miles groupfixcensus_groupid groupfixid 
sort fixcensus_groupid fixid
cd ../MatlabMain
outsheet using  "StataStructures2010MSANoClubForPaper.csv", replace comma

********************************************************************************

* This subsection creates id's of the firms which are used to calculate Herfindahl index
* when club stores are present
cd ../Stata
clear
use "club06wdates.dta"
gen countyid=substr(censusid,1,5)
merge m:1 countyid using "msa_county_small.dta"
keep if _merge==3
drop _merge
merge m:1 countyid using "NewYorkMSA5602counties.dta"
keep if _merge==1
drop _merge
append using "stores06_zip5_parname.dta"
keep if missing(msacode)==1 | (msacode!=5602 & msacode!=9999)
merge 1:1 latitude longitude volume using "stores06_clubForPaper.dta"
drop if _merge!=3
drop _merge
sum id, detail
distinct id
sum firmid2, detail

sort firmid2
egen groupfirmid2=group(firmid2) 
tab chain
tab sizecode
tab sgrpnm
gen sgrpnm1=substr(sgrpnm,1,1)
tab sgrpnm1
*sum groupfirmid2 if storname=="Wal Mart Supercenter"
sum groupfirmid2 if firmid2==20137
replace groupfirmid2=r(max) if sgrpnm1=="S"
sum groupfirmid2, detail
replace groupfirmid2=r(max)+1 if sgrpnm1=="B"
replace groupfirmid2=r(max)+2 if sgrpnm1=="C"

save "StoreID_FirmID.dta", replace
keep id groupfirmid2 storname



merge 1:m id using "fix_store_tract_idsclubForPaper.dta"
drop if _merge!=3
drop _merge
drop census_groupid fixcensus_groupid 
duplicates drop
* some stores were eliminated even though they are in msa, but they don't have tracts nearby
sort groupfirmid2
egen ggroupfirmid2=group(groupfirmid2)
save "GGFirmID.dta", replace
* id's of firm for Matlab are checked here


keep if  storname=="Giant Food" | storname=="Hannaford Bros Co"  | storname=="Whole Foods Market/HQ" | storname=="Wild Oats Markets Inc HQ"
keep storname ggroupfirmid2
sort storname
duplicates drop
drop storname
cd ../Tables
outsheet using  "ChainsIDSForHerfindahlWithClubs.csv", replace comma

cd ../Stata
clear
use "GGFirmID.dta"
keep groupfirmid2 ggroupfirmid2 
duplicates drop
save "GGFirmID_small.dta", replace


cd ../Stata
clear
use "StoreID_FirmID.dta"
keep id groupfirmid2 storname
merge 1:m id using "fix_store_tract_idsclubForPaper.dta"
drop if _merge!=3
drop _merge
drop census_groupid fixcensus_groupid 
duplicates drop
* some stores were eliminated even though they are in msa, but they don't have tracts nearby
merge m:1 groupfirmid2 using "GGFirmID_small.dta"
drop if _merge!=3
drop _merge


keep fixid ggroupfirmid2
cd ../Tables
sort fixid
outsheet using  "FirmIDsMSAClubs2006ForPaper.csv", replace comma

********************************************************************************

* This subsection creates id's of the firms which are used to calculate Herfindahl index
* when club stores are not present
cd ../Stata
clear
use "StoreID_FirmID.dta"

* Part which eliminates Club Stores
drop if clubstores==1

keep id groupfirmid2 storname





merge 1:m id using "fix_store_tract_idsclubForPaper.dta"
drop if _merge!=3
drop _merge
drop census_groupid fixcensus_groupid 
duplicates drop
* some stores were eliminated even though they are in msa, but they don't have tracts nearby
merge m:1 groupfirmid2 using "GGFirmID_small.dta"
drop if _merge!=3
drop _merge


* id's of firm for Matlab are checked here


keep if  storname=="Giant Food" | storname=="Hannaford Bros Co"  | storname=="Whole Foods Market/HQ" | storname=="Wild Oats Markets Inc HQ"
keep storname ggroupfirmid2
sort storname
duplicates drop
drop storname
cd ../Tables
outsheet using  "ChainsIDSForHerfindahlNoClubs.csv", replace comma
clear


cd ../Stata
clear
use "StoreID_FirmID.dta"

* Part which eliminates Club Stores
drop if clubstores==1

keep id groupfirmid2 storname





merge 1:m id using "fix_store_tract_idsclubForPaper.dta"
drop if _merge!=3
drop _merge
drop census_groupid fixcensus_groupid 
duplicates drop
* some stores were eliminated even though they are in msa, but they don't have tracts nearby
merge m:1 groupfirmid2 using "GGFirmID_small.dta"
drop if _merge!=3
drop _merge

keep fixid ggroupfirmid2
cd ../Tables
sort fixid
outsheet using  "FirmIDsMSANoClubs2006ForPaper.csv", replace comma


clear
cd ../Stata
use "censusTracts2010wIncome_nomerge.dta"
keep census_id census_groupid 
merge 1:m census_groupid using "fix_store_tract_idsclubForPaper.dta"
drop if _merge!=3
keep census_id census_groupid fixcensus_groupid 
duplicates drop
cd ../Tables
save "MSAClubTractsCorrespondenceForPaper.dta", replace
