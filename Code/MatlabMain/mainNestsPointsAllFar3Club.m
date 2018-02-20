function exitflag=mainNestsPointsAllFar3Club(pointNum)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up the type of estimation 

% year can be 1996 
%          or 2006
year=2006;

% typeModel 0 - fixed effect is the same for all chains
% typeModel 1 - fixed effect has different intercept for chains and same slope
% typeModel 2 - fixed effect has different intercept and slope for chains
typeModel=2;

% loadStataCsv 0 - do not load files from stata and use already created mat
% file

% loadStataCsv 1 - load files from stata and create mat
% file
loadStataCsv=0;

% derivativeCheck 0 - do not check analytical=numerical derivative 
% derivativeCheck 1 - check analytical=numerical derivative
derivativeCheck=0;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read csv file and create mat file or read data directly from mat file


if (year==2006)
    FileNameStructuresStata='StataStructures2010MSAClubForPaper.csv';
    FileNameStructuresMatlab='MatlabStructures2010MSAClubForPaper.mat';
    DemandStructsName='demandStructsOP2010MSAClubForPaper.mat';
    if (loadStataCsv==1)
        data=CsvToMat(FileNameStructuresStata,FileNameStructuresMatlab);
        [ts,storeRevenue]=setupMatlabStructsClub(data,DemandStructsName,year);
    end;
    if (loadStataCsv==0)
        load(DemandStructsName);
    end;
end;


numChainsC=max(ts.chainIDC);


%% Load initial point  

load('NestsInitialPointsAllFar.mat','points');
params=points(:,pointNum);
params=[params(1:end-3,1);0.8;params(end-2:end,1)];


    


% ts - is a structure, which includes utility variables. Utility variables
% are divided into common (the ones common for models 0 to 2) and different 
% parts (different part is saved into cells that correspond to a particular model) 

% Create a full utility Variables structure and remove auxiliary, which
% were used to save space and have structures for all three types of models
% for a particular year in one file
if (typeModel==0)
    ts.utilVar=[ts.utilVarCommon,ts.utilVarDifferent{1}];
end;
if (typeModel==1)
    ts.utilVar=[ts.utilVarCommon,ts.utilVarDifferent{2}];
end;
if (typeModel==2)
    ts.utilVar=[ts.utilVarCommon,ts.utilVarDifferent{3}];
end;
ts.utilVarCommon=[];
ts.utilVarDifferent=[];


% NEST CREATION
% ts.chainIDC:
% 17, 29 and 31 are Meijer, Target and Walmart (Supercenter Format)
% 36, 37 and 38 are BJ's, Costco and Sams (Club Format)
% The rest are grocery format
ts.nests=(1+1*(ts.chainIDC>35)+2*(1*(ts.chainIDC==17)+1*(ts.chainIDC==29)+1*(ts.chainIDC==31)));


% Compare analytical and numerical derivative
if (derivativeCheck==1)
    Pass=ObjectiveDerivativeCheckNests(params,ts,storeRevenue);
end;

if ((derivativeCheck==0) || (Pass==1))
    options=optimset('Display','iter','TolFun',1e-6,'TolX',1e-6,'GradObj','on');
    %options=optimset('TolFun',1e-6,'TolX',1e-6,'GradObj','on');

    exitflag=-999;
    maxtrials=1;
    trial=0;
            
    %Create upper and lower bounds for alpha (parameters that governs substitution within nest)

    lb=-Inf*ones(size(params));
    ub=Inf*ones(size(params));
    lb(end-5,1)=0.005;
    
    ub(end-5,1)=0.995;
    
    lb(end-3,1)=0.005;
    lb(end-4,1)=0.005;
    ub(end-3,1)=0.995;
    ub(end-4,1)=0.995;
    % these bounds are used for share of budget which is allocated to groceries	
    ub(end,1)=1;
    lb(end,1)=0;
     

    fprintf('Starting KNITRO for optimization...\n');
    %[xx, fval, exitflag, output] =knitromatlab(@(x) demandObjectiveNests(x,ts,storeRevenue),params,[],[],[],[],lb,ub,[],[],options,'koptions.opt');   
    while ((trial<maxtrials) && (exitflag<0))
       [xx, fval, exitflag, output] =knitromatlab(@(x) demandObjectiveNests(x,ts,storeRevenue),params,[],[],[],[],lb,ub,[],[],options,'koptions.opt');
        % If the algorithm gets stuck it starts in the point nearby
        
        params=xx+randn(size(params,1),1)/100;
        trial=trial+1;
        exitflag
    end
    save(strcat('resultsMSAClubDistxxForPaperHanafNestsPointsAllFar3Club_',num2str(pointNum),'_',num2str(year)),'xx','-v7.3');
    % Computes variance-covariance matrix and standard errors
    [ varcovar, standardErrors ] = getSE_opOPalphadensityNests( xx, ts, storeRevenue );
    % Clear view which was loaded from initial point, if the initial point
    % has not been loaded the command just does not do anything
    clear view;
    % Estimated Parameters, Standard Errors and t-values are created
    % This type of matrix is used as an imput to functions that produce latex tables 
    view=[xx,standardErrors,xx./standardErrors];
    % Results are saved in a mat file
    cd ../Tables	
    save(strcat('resultsMSAClubDistForPaperHanafNestsPointsAllFar3Club_',num2str(pointNum),'_',num2str(year)),'view','storeRevenue','fval','output','exitflag','-v7.3');

end
