function [storeRevenue, DerRev, storeChainMap ] = getClubNestsStoreDiversion( params, ts, storeRevenue, NUcommon, storeID, chainID )


    % Unpack the parameter vector into lambda, beta, and tau. 
    numChains = max(ts.chainID);
    numChainsC = max(ts.chainIDC);
    numNests=max(ts.nests);
   
    betas=params(1:end-3-numNests);
    lambda=params(end-3-numNests+1:end-3);
    aalpha=params(end-2:end-1);
    alpha=params(end);
    cd ../MatlabMain
    
    u = getUtilityGen(ts, betas); 
    [ts_shares, nestProb, sumUexpul, sumexpul] = getShareGenOPdensity3Nests(ts,u,aalpha,lambda); % lambda need to be a vector
    rev_hat = getRevOPalpha(ts, ts_shares, alpha);   
    
    numStores=length(storeRevenue);
    numParams=length(params);
    cd ../Tables
    [SharesTimesUtilVarByTract] = getSharesTimesUtilVarByTractOPChain(1*(ts.storeID==storeID).*ts_shares, ts, chainID, NUcommon);
    
    
  
    
    SharesWithinTimesUtilVarByTractNestRelevant=zeros(size(ts.tractID,1),1);
        for i=1:1:numNests
            [SharesWithinTimesUtilVarByTractNest] = getSharesTimesUtilVarByTractOPChain(1*(ts.storeID==storeID).*(ts.nests==i).*ts_shares./(nestProb(ts.tractID+(i-1)*max(ts.tractID))+1*(ts.nests~=i)), ts, chainID, NUcommon);
            % Structure that is used to calculate derivative of the shares
            % with respect to utility parameters
            SharesWithinTimesUtilVarByTractNestRelevant=SharesWithinTimesUtilVarByTractNestRelevant+SharesWithinTimesUtilVarByTractNest.*(repmat(ts.nests,1,1)==i);
        end;
    % Function that calculates SemiElasticity matrix
    cd ../Tables
   [storeRevenue, DerRev, storeChainMap ] = getGenDerMatrixInterOPClubNestsChain(SharesTimesUtilVarByTract,SharesWithinTimesUtilVarByTractNestRelevant, ts_shares, ts, alpha, storeRevenue, NUcommon, lambda, storeID, chainID);
 
end

