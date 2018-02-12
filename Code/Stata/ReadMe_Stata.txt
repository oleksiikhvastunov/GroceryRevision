This file provides information about stata code that accompanies 
"Measuring Competition in Spatial Retail: Application to Groceries"
by Paul Ellickson, Paul Grieco, and Oleksii Khvastunov.

Files which are in the directory initially:
	storepanel.dta
	club06wdates.dta
	censusTracts2010wIncome.dta
	msa_county.dta
	1_Data_Cleaning.do
	2_Matlab_structures.do
	ReadMe_Stata.txt

The rest of the files are produces by the code.

The code uses version Stata 14.0
and contains:

1) 1_Data_Cleaning.do
This script takes
	storepanel.dta - data on non club supercenter and supermarkets for 1996-2006 (location, parent company, size, revenue)
	club06wdates.dta - data on 2006 club stores (location, parent company, size, revenue )
	censusTracts2010wIncome.dta - data on 2010 census tracts (location, population, income, density)
cleans them and prepares to be used in 2_Matlab_Structures.do

Another input file is msa_county.dta which shows correspondence between MSA code and county code (which counties belong to MSA)

Files produces by this part of the code are:
	ClubStores2006SmallPaper.dta
	msa_county_small.dta
	NewYorkMSA5602counties.dta
	stores06_clubForPaper.dta
	stores06_zip5.dta
	stores06_zip5_parname.dta
	stores06_zip5_smallparnameformatForPaper.dta
	censusTracts2010wIncome_nomerge.dta
	censusTracts2010wIncome_small.dta
	censusTracts_id.dta
	
2) 2_Matlab_Structures.do

This script takes output of 1_Data_Cleaning.do and produces 
	StataStructures2010MSAClubForPaper.csv 
	and 
	StataStructures2010MSANoClubForPaper.csv 
files that are used as an input for Demand Model, which is estimated in Matlab. 

StataStructures2010MSAClubForPaper.csv contains store-tract pairs for the model that includes grocery, supercenters and club stores. Each row in the stucture also 
contains characteristics of store and tract in question. It is done this way in order to calculate utilities of the stores as simple
matrix multiplication.

StataStructures2010MSANoClubForPaper.csv contains store-tract pairs for the model that includes only grocery and supercenter stores.
