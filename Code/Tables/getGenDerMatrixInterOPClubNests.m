function [derMatrixExtended, derMatrixSemiElasticities ] = getGenDerMatrixInterOPClubNests(SharesTimesUtilVarByTract,SharesWithinTimesUtilVarByTractNest, shares, ts, alpha, storeRevenue, NUcommon, lambda)
%   This function constructs the Chains semielesticity matrix
%
%   ContractedForUtilityVar ... Derivative of Rev_hat with respect to
%   Utility variables, some of which reflect chain utilities

%   twoTimesRevenueDifference ... Derivative of objective function with respect to rev_hat. 

    numStores=max(ts.storeID);
    numChains=max(ts.chainID);
    numChainsC=max(ts.chainIDC);

    numUtilVar=size(ts.utilVar,2);
    ContractedForUtilVar=zeros(numStores,numUtilVar);

    derMatrixExtended=zeros(numChainsC,numChainsC);
    storeChainMap=unique([ts.storeID,ts.chainIDC],'rows');
    chainRevenue=accumarray(storeChainMap(:,2),storeRevenue);
    
    for i=1:1:numUtilVar
        ContractedForUtilVar(:,i)=accumarray(ts.storeID,alpha*ts.inc.*ts.pop.*(((1./lambda(ts.nests)).*shares.*ts.utilVar(:,i)-shares.*SharesTimesUtilVarByTract(:,i))+shares.*(1-(1./lambda(ts.nests))).*SharesWithinTimesUtilVarByTractNest(:,i)));
        % Taking the relevant utility variables that reflect increase in
        % the Chain utilities 
        if ((i>NUcommon) && (i<numChainsC+NUcommon+1))
            
            derMatrixExtended(:,i-NUcommon)=accumarray(storeChainMap(:,2),ContractedForUtilVar(:,i));
        end;
        
    end;

    derMatrixSemiElasticities=derMatrixExtended./repmat(chainRevenue,1,numChainsC);


    
    
end

