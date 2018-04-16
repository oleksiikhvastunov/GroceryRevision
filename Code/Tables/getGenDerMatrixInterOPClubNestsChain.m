function [storeRevenue, DerRev, storeChainMap  ] = getGenDerMatrixInterOPClubNestsChain(SharesTimesUtilVarByTract,SharesWithinTimesUtilVarByTractNest, shares, ts, alpha, storeRevenue, NUcommon, lambda, storeID, chainID)
%   This function constructs the Chains semielesticity matrix
%
%   ContractedForUtilityVar ... Derivative of Rev_hat with respect to
%   Utility variables, some of which reflect chain utilities

%   twoTimesRevenueDifference ... Derivative of objective function with respect to rev_hat. 

    numStores=max(ts.storeID);
    numChains=max(ts.chainID);
    numChainsC=max(ts.chainIDC);

    numUtilVar=size(ts.utilVar,2);
    ContractedForUtilVar=zeros(numStores,1);

    %derMatrixExtended=zeros(numChainsC,numChainsC);
    storeChainMap=unique([ts.storeID,ts.chainIDC],'rows');
    %chainRevenue=accumarray(storeChainMap(:,2),storeRevenue);
    
    for i=1:1:numUtilVar
        if (i==NUcommon+chainID)
            ContractedForUtilVar(:,1)=accumarray(ts.storeID,alpha*ts.inc.*ts.pop.*(((1./lambda(ts.nests)).*shares.*ts.utilVar(:,i)*1.*(ts.storeID==storeID)-shares.*SharesTimesUtilVarByTract(:,1))+shares.*(1-(1./lambda(ts.nests))).*SharesWithinTimesUtilVarByTractNest(:,1)));
        end;
        % Taking the relevant utility variables that reflect increase in
        % the Chain utilities 
        %if ((i>NUcommon) && (i<numChainsC+NUcommon+1))
            
        %    derMatrixExtended(:,i-NUcommon)=accumarray(storeChainMap(:,2),ContractedForUtilVar(:,i));
        %end;
        
    end;
    DerRev = ContractedForUtilVar(:,1);

    %derMatrixSemiElasticities=derMatrixExtended./repmat(chainRevenue,1,numChainsC);


    
    
end

