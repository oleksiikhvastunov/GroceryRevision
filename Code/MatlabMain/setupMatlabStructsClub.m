function [ts,storeRevenue]=setupMatlabStructsClub(data,DemandStructsName,year)

% Function that tracnforms raw data from data matrix to ts structure which
% is saved into mat file DemandStructsName

% typeModel determines which specification is used:
% 0 - utility does not depend on chain identity
% 1 - intercept of fixed effect depends on chain identity
% 2 - intercept and slope of fixed effect depends on chain identity


% Data organized in the following form (columns):
% 1 fixcensus_groupid
% 2 distance_miles
% 3 volume
% 4 id_format
% 5 fixid
% 6 pop10
% 7 logpcincome
% 8 size
% 9 chk_sqft
% 10 density
% 11 hhsize
% 12 logfte
% 13 logchkt
% 14 id_chain
% 15 logpcincomedemean
% 16 Club store size (if not club then size==1)
% 17 Club store distance (if not club then distance=0)

%ts is a list of tract-store vectors needed to calculate the utility of
%each store from a given tract. 

% Log income of a tract
ts.logInc=full(data(:,7));


% corresinc is used for normalization
corresinc=25000;
ts.corresinc=corresinc;
% This one is done in order to have all the variables comprable in magnitude 
ts.incDiff=full((exp(data(:,7))-corresinc)/10000);

% Density in the 5 mile radius 
ts.density=data(:,10);
data(:,9:10)=[];
% weekly income
ts.inc=exp(ts.logInc)/52;

if (year==1996)
% Normalized income
    ts.logInc=(ts.logInc-log(24511)); % (24511 and 24501 correspondingly are median income weighted by tract pop)
end;
if (year==2006)
% Normalized income
    ts.logInc=(ts.logInc-log(24501)); % (24511 and 24501 correspondingly are median income weighted by tract pop)
end;

% Household size
ts.hhSize=full(data(:,9));

% Tract id
ts.tractID = full(data(:,1));

% Store id
ts.storeID = full(data(:,5));

% Distance between store and population weighted tract centroid
ts.dist = full(data(:,2));

% Tract population in thousands (zero population tracts were removed in stata, before it was done population of tracts were capped below by 10 people)
ts.pop  = full(max(data(:,6),10)/1000);

% Format id
ts.chainID = full(data(:,4));

% Chain id
ts.chainIDC = full(data(:,12));

% it is actually number of formats now (it is more convenient to utilize previous code in this way)
numChains = max(ts.chainID);
% this one is number of chains
numChainsC = max(ts.chainIDC);

% Utility variables, that are used in all model specifications
ts.utilVarCommon = [ts.hhSize,ts.hhSize.*ts.logInc,data(:,2),ts.logInc.*data(:,2),log(data(:,8)),ts.logInc.*log(data(:,8)),data(:,10),ts.logInc.*data(:,10),data(:,11),ts.logInc.*data(:,11),log(data(:,14)),ts.logInc.*log(data(:,14)),data(:,15),ts.logInc.*data(:,15)];
clear size;
% Number of store-tract pairs
numPairs=size(ts.logInc,1);

% We extend data with chain ids
% Making utility variables as sparse matrix occupies only 1/7 of space in
% the memory compared to full matrix
data(:,14:15)=[];

data=[data,(repmat(ts.chainID,1,numChains)==repmat(1:1:numChains,numPairs,1)),(repmat(ts.chainIDC,1,numChainsC)==repmat(1:1:numChainsC,numPairs,1))];

% Model 0
ts.utilVarDifferent{1}=sparse([ones(numPairs,1),ts.logInc]);


% Model 1
ts.utilVarDifferent{2}=sparse([data(:,14+numChains:(14+numChains+numChainsC-1)),ts.logInc]);


% Model 2
ts.utilVarDifferent{3}=sparse([data(:,14+numChains:(14+numChains+numChainsC-1)),data(:,14+numChains:(14+numChains+numChainsC-1)).*(repmat(ts.logInc,1,numChainsC))]);

 

%The total revenue of each store is listed here. 
% Store revenue is transformed from vector which is indexed by store-tract
% pair to vector which has size equal to number of stores 
storeRevenue_uni = unique([ts.storeID full(data(:,3))], 'rows');
% We check that each store has at least one tract nearby
storeRevenue(storeRevenue_uni(:,1)) = storeRevenue_uni(:,2); 
storeRevenue = storeRevenue';
if length(storeRevenue) ~= storeRevenue_uni
   sprintf('Warning: We seem to have stores which are not in the choice set of any tract'); 
else
    clear storeRevenue_uni;
end




storeRevenue=full(storeRevenue);
if (year==1996)
    % This transforms 1996 dollars (Revenue of the stores) to 2010 dollars (census income)
    storeRevenue=1.3898*storeRevenue;
end;

if (year==2006)
    % This transforms 2006 dollars (Revenue of the stores) to 2010 dollars (census income)
    storeRevenue=1.0816*storeRevenue;
end;
clear data
clear tractPop
save(DemandStructsName,'ts', 'storeRevenue','-v7.3');

