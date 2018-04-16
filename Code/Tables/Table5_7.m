%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This section contains code for the Table 5 which has estimates of the
% parameters and standard errors for the main specification and robustness checks

clear

% Main specification (with nests and club stores)
load('resultsMSAClubDistForPaperHanafNestsPointsAllFar3ClubFminunc_1_2006');
v{1,1}=view;
r2(1,1)=1-fval/(size(storeRevenue,1)*var(log(storeRevenue)));

% Multinomial logit (no nests)
load('resultsMSAClubDistForPaperHanaf_2_2006.mat')
v{1,2}=view;
r2(1,2)=1-fval/(size(storeRevenue,1)*var(log(storeRevenue)));

% Specification without club stores (with nests)
load('resultsMSANoClubDistForPaperHanafNestsPointsAllFar3_5_2006')
v{1,3}=view;
r2(1,3)=1-fval/(size(storeRevenue,1)*var(log(storeRevenue)));

% Specification with nests and club stores, but without fte and checkouts
% for supermarkets and supercenters
load('resultsMSAClubDistForPaperHanafNestsPointsAllFar3ClubSame_29_2006')
v{1,4}=view;
r2(1,4)=1-fval/(size(storeRevenue,1)*var(log(storeRevenue)));

% Ordering of the parameters such that they will follow clear order and
% will have correspondence between specifications
vv{1,1}=[v{1,1}(3:6,:);v{1,1}(7:10,:);v{1,1}([13,14,11,12],:);[-v{1,1}(1:2,1),v{1,1}(1:2,2:3)];v{1,1}(end-2:end-1,:);v{1,1}(end-5,:);v{1,1}([end-3,end-4],:);v{1,1}(end,:)];
vv{1,2}=[v{1,2}(3:6,:);v{1,2}(7:10,:);v{1,2}([13,14,11,12],:);[-v{1,2}(1:2,1),v{1,2}(1:2,2:3)];v{1,2}(end-2:end-1,:);zeros(2,3);zeros(1,3);v{1,2}(end,:)];

vv{1,3}=[v{1,3}(3:6,:);v{1,3}(7:10,:);zeros(4,3);[-v{1,3}(1:2,1),v{1,3}(1:2,2:3)];v{1,3}(end-2:end-1,:);v{1,3}(end-4,:);v{1,3}(end-3,:);zeros(1,3);v{1,3}(end,:)];
vv{1,4}=[v{1,4}(3:6,:);zeros(4,3);v{1,4}([9,10,7,8],:);[-v{1,4}(1:2,1),v{1,4}(1:2,2:3)];v{1,4}(end-2:end-1,:);v{1,4}(end-5,:);v{1,4}([end-3,end-4],:);v{1,4}(end,:)];



% Row labels for the Table 5 
rows={'dist';'dist*log(inc)';'log(size)';'log(size)*log(inc)';'log(fte)';'log(fte)*log(inc)';'log(chk)';'log(chk)*log(inc)';'dist';'dist*log(inc)';'log(size)';'log(size)*log(inc)';'hhsize';'hhsize*log(inc)';'log(density)';'log(density)$^2$';'$\lambda_{grocery}$';'$\lambda_{supercenters}$';'$\lambda_{club}$';'$\alpha$'};

% Creating latex code for the Table 5 which will be written in the
% Table5.tex file
cd ../TablesOutput
mymatlabtolatexr2( vv, 'Table5.tex', 'Table5', {'','(1)','(2)','(3)','(4)'} ,rows, r2  )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This subsection contains code for the Table 6 which contains distance and
% income elasticities for the large chains for the main specification

clear
cd ../MatlabMain
load('demandStructsOP2010MSAClubForPaper.mat')
cd ../Tables
load('resultsMSAClubDistForPaperHanafNestsPointsAllFar3ClubFminunc_1_2006');
NUcommon=size(ts.utilVarCommon,2);
ts.utilVar=[ts.utilVarCommon,ts.utilVarDifferent{3}];
ts.utilVarCommon=[];
ts.utilVarDifferent=[];

% NEST CREATION
% ts.chainIDC:
% 17, 29 and 31 are Meijer, Target and Walmart (Supercenter Format)
% 36, 37 and 38 are BJ's, Costco and Sams (Club Format)
% The rest are grocery format
ts.nests=(1+1*(ts.chainIDC>35)+2*(1*(ts.chainIDC==17)+1*(ts.chainIDC==29)+1*(ts.chainIDC==31)));


% Function that calculates income and distance elasticities for the chains
[ distanceEf, incomeEf ] = getElasticitiesGenOPClubNests( view(:,1), ts);
% Indexing is used to create order of chains which is used in the Table6,
% because we want Supercenters and Club Stores to be consecutive rows in
% the table
ind=zeros(size(distanceEf));
ind(17,1)=1;
ind(29,1)=1;
ind(31,1)=1;
ind(36,1)=2;
ind(37,1)=2;
ind(38,1)=2;
distanceEfmod=[distanceEf(ind==0,1);distanceEf(ind==1,1);distanceEf(ind==2,1)];
incomeEfmod=[incomeEf(ind==0,1);incomeEf(ind==1,1);incomeEf(ind==2,1)];

% Load name of the chains
cd ../Tables
load('ChainsForPaper.mat');
chainsmod=[chains(ind==0,1);chains(ind==1,1);chains(ind==2,1)];
% Creating latex code for the Table6 in the Table6.tex file
cd ../TablesOutput
mymatlabtolatexRegular( full([distanceEfmod,incomeEfmod]), 'Table6.tex', 'Table6',  {'','Distance Elasticity','Income Elasticity'}, chainsmod );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This subsection contains code for the Table 7 which calculates main
% competitors for the large chains based on semeelasticities

clear
cd ../MatlabMain
load('demandStructsOP2010MSAClubForPaper.mat')
cd ../Tables
load('resultsMSAClubDistForPaperHanafNestsPointsAllFar3ClubFminunc_1_2006','view');
NUcommon=size(ts.utilVarCommon,2);
ts.utilVar=[ts.utilVarCommon,ts.utilVarDifferent{3}];
ts.utilVarCommon=[];
ts.utilVarDifferent=[];

load('ChainsForPaper.mat');

% NEST CREATION
% ts.chainIDC:
% 17, 29 and 31 are Meijer, Target and Walmart (Supercenter Format)
% 36, 37 and 38 are BJ's, Costco and Sams (Club Format)
% The rest are grocery format
ts.nests=(1+1*(ts.chainIDC>35)+2*(1*(ts.chainIDC==17)+1*(ts.chainIDC==29)+1*(ts.chainIDC==31)));

params=view(:,1);
% Indexing is used to create order of chains which is used in the Table7,
% because we want Supercenters and Club Stores to be consecutive rows in
% the table

ind=zeros(size(chains));
ind(17,1)=1;
ind(29,1)=1;
ind(31,1)=1;
ind(36,1)=2;
ind(37,1)=2;
ind(38,1)=2;

% Function that calculates the semielasticity matrix
[ derMatrix, derMatrixSemiElasticities ] = getMainCompetitorsSemiElasticitiesClubNests( params, ts, storeRevenue, NUcommon );



[sortSemi,index]=sort(derMatrixSemiElasticities,2,'descend');

derMatrixSemiElasticitiesmod=[derMatrixSemiElasticities(ind==0,:);derMatrixSemiElasticities(ind==1,:);derMatrixSemiElasticities(ind==2,:)];
sortSemimod=[sortSemi(ind==0,:);sortSemi(ind==1,:);sortSemi(ind==2,:)];
indexmod=[index(ind==0,:);index(ind==1,:);index(ind==2,:)];

chainsmod=[chains(ind==0,1);chains(ind==1,1);chains(ind==2,1)];

% Function that creates latex code for the Table 7 which is written in the
% Table7.tex
cd ../TablesOutput
mymatlabtolatexRegularCompNewOutsideInside( [sortSemimod(:,[1,end,end-1])], indexmod(:,[1,end,end-1]), 'Table7.tex', 'Table7', {'Chain','Own SemiElast','First Comp','SemiElast','Second Comp','SemiElast'}, chains,-1*sum(derMatrixSemiElasticitiesmod,2), sortSemimod(:,1)-sum(derMatrixSemiElasticitiesmod,2));


