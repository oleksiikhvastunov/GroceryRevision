function [ varcovar, standardErrors ] = getSE_opOPalphadensityNests( params, ts, storeRevenue )
 
    numChains= max(ts.chainID);
    numChainsC=max(ts.chainIDC);
    
      
    
    numNests=max(ts.nests);
  
    % unpack params vetor into parts that correspond to chain effects, nesting parameters, outside option parameters and grocery budget parameter
    betas=params(1:end-3-numNests);
    lambda=params(end-3-numNests+1:end-3);
    aalpha=params(end-2:end-1);
    alpha=params(end);
    numNests=max(ts.nests);
    
    u = getUtilityGen(ts, betas); 
    [ts_shares, nestProb, sumUexpul, sumexpul] = getShareGenOPdensity3Nests(ts,u,aalpha,lambda); % lambda need to be a vector
    rev_hat = getRevOPalpha(ts, ts_shares, alpha);   
    
    numStores=length(storeRevenue);
    numParams=length(params);
    
     
    [SharesTimesUtilVarByTract] = getSharesTimesUtilVarByTractOP(ts_shares, ts);
        
    SharesWithinTimesUtilVarByTractNestRelevant=zeros(size(ts.tractID,1),size(betas,1));
    
    for i=1:1:numNests
        [SharesWithinTimesUtilVarByTractNest] = getSharesTimesUtilVarByTractOP(1*(ts.nests==i).*ts_shares./(nestProb(ts.tractID+(i-1)*max(ts.tractID))+1*(ts.nests~=i)), ts);
        SharesWithinTimesUtilVarByTractNestRelevant=SharesWithinTimesUtilVarByTractNestRelevant+SharesWithinTimesUtilVarByTractNest.*(repmat(ts.nests,1,size(betas,1))==i);
    end;
    
    % Derivative of the store Revenue with respect to parameters of the
    % model. It is required to calculate the variance-covariance matrix and
    % standard errors.
    [derErrorByStore] = getErrorDerivativeByStoreOPalphadensityNests(SharesTimesUtilVarByTract, SharesWithinTimesUtilVarByTractNest, ts_shares, ts, storeRevenue,rev_hat,alpha, lambda, u, sumUexpul, sumexpul, nestProb);

    
    
    outerProduct=zeros(numParams,numParams);
    for i=1:1:numStores
        
        outerProduct=outerProduct+(1/numStores)*derErrorByStore(:,i)*derErrorByStore(:,i)';
    end;
    varcovar=inv(outerProduct)/numStores;
    standardErrors=diag(varcovar).^0.5;
end

