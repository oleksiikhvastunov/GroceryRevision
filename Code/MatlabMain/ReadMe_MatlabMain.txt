README:

This explains content of the folder MatlabMain, which is the code that performs demand estimation for the main specification for for “Measuring Competition and Spatial Retail”

The code can be run by the function:
	mainNestsPointsAllFar3Club(pointNum) 
where pointNum is a number that represents initial point which is taken for the estimation.
For example mainNestsPointsAllFar3Club(1) will run estimation with first starting point. 

Results of demand estimation are saved in:
	resultsMSAClubDistxxForPaperHanafNestsPointsAllFar3Club_pointNum_2006.mat 
	resultsMSAClubDistForPaperHanafNestsPointsAllFar3Club_pointNum_2006.mat
which are located in Tables folder,
for example 
resultsMSAClubDistForPaperHanafNestsPointsAllFar3Club_1_2006.mat
contains results with first starting point. 

The file:
	koptions.opt
contains option required for knitromatlab optimization routine which is called in the 
mainNestsPointsAllFar3Club.m

Starting point (30 of them) are stored in the file:
	NestsInitialPointsAllFar.mat   

Input data is given by:
	StataStructures2010MSAClubForPaper.csv
which is taken by 
	CsvToMat.m 
file and saved into 
	MatlabStructures2010MSAClubForPaper.mat
which in turn is used by 
	setupMatlabStructsClub.m
and saved into
	demandStructsOP2010MSAClubForPaper.mat
which can be supplied directly to the demand estimation routine if loadStataCsv=0 in the mainNestsPointsAllFar3Club. demandStructsOP2010MSAClubForPaper.mat contains vector of store revenues
storeRevenue and structure ts which includes store and tract id's for the tract-store pairs (saved in ts.storeID and ts.tractID) and utility variables (which are saved in ts.utilVarCommon and ts.utilVarDifferent that reflect utility variables which are common and different across specifications with different flexibility for chain fixed effects)

The function:
	ObjectiveDerivativeCheckNests.m 
takes initial point and checks if the analytical derivative of the objective function coincides with the numerical derivative. This check is done if derivativeCheck==1 in the mainNestsPointsAllFar3Club.

The function:
	demandObjectiveNests.m
takes initial point and returns value of the objective function which is needed to be minimized 
or value of the objective function and analytical derivative (depending on the number of the output arguments).

The function:
	getUtilityGen.m 
calculates utilities of spending a dollar in the store for tract-store pair. Output of the function is vector where each element correcponds to particular tract-store pair (id of the tracts is in ts.tractID and id of the store is in ts.storeID)

The function:
	getShareGenOPdensity3Nests.m
produces shares that representative consumer in the tract is alocating to the particular store. The function also produces probabilities within nest and two sructures which are used for calculating analytical derivatives of the objective function.

The function:
	getRevOPalpha.m
produces predicted revenues for the stores, which will be later on used for calculating value of the objective function. 

The functions:
	getSharesTimesUtilVarByTractOP.m
	gradObjOPalphadensityNests.m
are used to calculate analytical gradient of the objective function.

The function:
	getSE_opOPalphadensityNests.m
calculates standard errors of the estimates of the parameters and calls
	getErrorDerivativeByStoreOPalphadensityNests.m
as it's subroutine.
