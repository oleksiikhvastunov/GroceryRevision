function [SharesTimesUtilVarByTract] = getSharesTimesUtilVarByTractOP(shares, ts)
% SharesTimesUtilVarByTract are required as intermediate step to calculate the
% analytical derivate of the objective function

%   ContractedSharesTimesDistanceByTract(i,j) contains sum of share*utilVar_j of all stores close to tract i (to do this we sum up over all stores
%   that are close to tract i) 
%   SharesByTractChain(i,j) - is expanded ContractedSharesByTractChain,
%   where i corresponds to store-tract pair and j coreesponds to utility Variable j 

    numUtilVar=size(ts.utilVar,2);
    numTracts = max(ts.tractID);
    numPairs = size(ts.chainID,1);
    
    ContractedSharesTimesUtilVarByTract=zeros(numTracts,numUtilVar);
    
    SharesTimesUtilVarByTract=zeros(numPairs,numUtilVar);
    
    
    for i=1:1:numUtilVar
        ContractedSharesTimesUtilVarByTract(:,i)=accumarray(ts.tractID,shares.*(ts.utilVar(:,i)));
        
        SharesTimesUtilVarByTract(:,i)=ContractedSharesTimesUtilVarByTract(ts.tractID(:,1),i);
        
    end;
end

