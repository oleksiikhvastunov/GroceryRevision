/* This file updates censusTractswIncome2010.csv so that we can address referee comments. 
   We will:
	  * Incorporate vehicle ownership data downloaded from American Fact Finder using the American Community Survey.
	  * Incorproate MSA data from our store data, storepanel.dta. 
*/ 


/// Step 1: Merge together the AFF Data into a single dataset of census tracts. 

// We first used text-edit to clean the CSV files for easy input into STATA.
// Now import those files and append:
clear all

cd /Users/plgrie/Dropbox/EGK_Supermarkets/VehicleData/PrepVehicleData 

insheet using /Users/plgrie/Dropbox/EGK_Supermarkets/VehicleData/AFF_ACS5yr/Vehicle_AMissi/ACS_10_5YR_DP04_insheet.csv, clear

save AMissi, replace

insheet using /Users/plgrie/Dropbox/EGK_Supermarkets/VehicleData/AFF_ACS5yr/Vehicle_MissoZ/ACS_10_5YR_DP04_insheet.csv, clear

append using AMissi

erase AMissi.dta

// Now some basic cleaning: 
rename geoid geoid_long
rename geoid2 geoid
format %011.0f geoid

//Get percentage of households with Access to a vehicle:
gen vehicle = 100 - hc03_vc82
label variable vehicle "Percentage of Households with Access to Vehcile"

save vehicle, replace

//////////////////////////////////////////////////////////////////////////
///Now merge vehicle data into the main dataset:
clear

use /Users/plgrie/Dropbox/EGK_Supermarkets/VehicleData/OldFiles/censusTracts2010wIncome.dta

drop _merge

merge 1:1 geoid using vehicle, keepusing(vehicle geodisplaylabel)



//Use geodisplaylabel to visually verify that merge is working
//There are unused tracts for our work (e.g., Alaska), remove them: 
drop if _merge == 2
drop _merge

//Get FIPS code from geoid
gen fips = floor(geoid/1000000)
format %05.0f fips
label variable fips "State-County FIPS code"

erase vehicle.dta
save censusTracts2010wIncome.dta, replace

/////////////////////////////////////////////////////////////////////////////////
// Now use storepanel to construct MSA to FIPS crosswalk

clear 
use /Users/plgrie/Dropbox/EGK_Supermarkets/VehicleData/OldFiles/storepanel.dta
//keep if period == 13

contract fips msacode
format %05.0f fips

gsort fips -_freq
gen dup = fips == fips[_n-1]
gen preDup = fips == fips[_n+1]

//There are some duplicate MSA codes, even though MSAs should be collections of counties, 
//this is probably due to poor MSA reporting on the part of TDLinx, to deal wiht it, 
//we will assign a county to its most populus (by store count in 2006) MSA if the duplicate
//is between MSA and no MSA, we will assign it to the numbered MSA. 
replace msacode = msacode[_n+1] if preDup ==1 & msacode == 9999
drop if dup == 1
drop dup preDup


save fipsMSA, replace

//Passes visual comparison to the official crosswalk "http://www.nber.org/data/cbsa-msa-fips-ssa-county-crosswalk.html"

/////////////////////////////////////////////////////////////////////////////////
// Add MSAcode to tract level data
clear
use censusTracts2010wIncome.dta
merge m:1 fips using fipsMSA, keepusing(msacode)

//These are Alaska and Hawaii: 
drop if _merge == 2

//Spot-Checked these counties with no stores, they all appear to be extremely rural. 
//Therefore assigning them to no MSA. 
replace msacode = 9999 if _merge == 1

drop _merge

save censusTracts2010wIncome.dta, replace
outsheet using censusTracts2010wIncome.csv, comma replace


