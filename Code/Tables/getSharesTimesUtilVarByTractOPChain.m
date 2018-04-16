function [SharesTimesUtilVarByTract] = getSharesTimesUtilVarByTractOPChain(shares, ts, chainID, NUcommon)
% SharesTimesUtilVarByTract are required as intermediate step to calculate the
% analytical derivate of the objective function

%   ContractedSharesTimesDistanceByTract(i,j) contains sum of share*utilVar_j of all stores close to tract i (to do this we sum up over all stores
%   that are close to tract i) 
%   SharesByTractChain(i,j) - is expanded ContractedSharesByTractChain,
%   where i corresponds to store-tract pair and j coreesponds to utility Variable j 

    numUtilVar=size(ts.utilVar,2);
    numTracts = max(ts.tractID);
    numPairs = size(ts.chainID,1);
    
    ContractedSharesTimesUtilVarByTract=zeros(numTracts,1);
    
    SharesTimesUtilVarByTract=zeros(numPairs,1);
    
    
    for i=1:1:numUtilVar
        if (i==chainID+NUcommon)
            ContractedSharesTimesUtilVarByTract(:,1)=accumarray(ts.tractID,shares.*(ts.utilVar(:,i)));
            SharesTimesUtilVarByTract(:,1)=ContractedSharesTimesUtilVarByTract(ts.tractID(:,1),1);
        end;
        
    end;
end

