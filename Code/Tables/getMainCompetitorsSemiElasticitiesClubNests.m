function [ derMatrix, derMatrixSemiElasticities ] = getMainCompetitorsSemiElasticitiesClubNests( params, ts, storeRevenue, NUcommon )


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
    
    [SharesTimesUtilVarByTract] = getSharesTimesUtilVarByTractOP(ts_shares, ts);
    
    
  
    
    SharesWithinTimesUtilVarByTractNestRelevant=zeros(size(ts.tractID,1),size(betas,1));
        for i=1:1:numNests
            [SharesWithinTimesUtilVarByTractNest] = getSharesTimesUtilVarByTractOP(1*(ts.nests==i).*ts_shares./(nestProb(ts.tractID+(i-1)*max(ts.tractID))+1*(ts.nests~=i)), ts);
            % Structure that is used to calculate derivative of the shares
            % with respect to utility parameters
            SharesWithinTimesUtilVarByTractNestRelevant=SharesWithinTimesUtilVarByTractNestRelevant+SharesWithinTimesUtilVarByTractNest.*(repmat(ts.nests,1,size(betas,1))==i);
        end;
    % Function that calculates SemiElasticity matrix
   cd ../Tables 
   [derMatrix, derMatrixSemiElasticities ] = getGenDerMatrixInterOPClubNests(SharesTimesUtilVarByTract,SharesWithinTimesUtilVarByTractNestRelevant, ts_shares, ts, alpha, storeRevenue, NUcommon, lambda);
 
end

