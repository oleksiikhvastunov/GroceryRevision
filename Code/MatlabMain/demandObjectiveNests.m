function [ obj, grad ] = demandObjectiveNests( params, ts, storeRevenue )
    % Objective function
    % obj - value of the objective function,
    % grad - analytical gradient of the Objective function
    % params - value of the parameters
    % ts - data structure
    % storeRevenue - vector of store Revenues

     
  
    % Unpack the parameter vector into betas which correspond to utility
    % Variables, aalpha which correspond to density variables in the
    % outside option and alpha which governs food budget as a share of
    % income
    numNests=max(ts.nests);
  
    % parameters that capture chain effects (intercept and slope)
    betas=params(1:end-3-numNests);
    % parameters that capture substitution within nest
    lambda=params(end-3-numNests+1:end-3);
    % parameters that are used for outside option
    aalpha=params(end-2:end-1);
    % parameter that capture grocery budget as a share of income
    alpha=params(end);
    numNests=max(ts.nests);
    
    % Calculate utilities of the store ts.storeID which are in the choice set of ts.tractID 
    % (u is indexed by store-tract pair)
    u = getUtilityGen(ts, betas); 
    
    % Calculate shares based on utilities u, ts_shares have the same size
    % as u
    % nestProb, sumUexpul, sumexpul are matrices of the size
    % numTracts*numNests. For example, nestProb(i,j) is share of nest j
    % stores in tract i. sumUexpul and sumexpul are matrices which are used
    % for analytical derivative calculations
    [ts_shares, nestProb, sumUexpul, sumexpul] = getShareGenOPdensity3Nests(ts,u,aalpha,lambda); 
    rev_hat = getRevOPalpha(ts, ts_shares, alpha); 
    obj = sum((log(rev_hat) - log(storeRevenue)).^2); 
    
    
    if nargout > 1 
        % Object which is used to calculate derivative of shares with
        % respect to ulitity parameters, which is in turn will be used for
        % derivative of the objective function with respect to utility
        % parameters
        % SharesTimesUtilVarByTract has number of store-tract pair rows and
        % number of utility variables columns
        [SharesTimesUtilVarByTract] = getSharesTimesUtilVarByTractOP(ts_shares, ts);
        
        
        SharesWithinTimesUtilVarByTractNestRelevant=zeros(size(ts.tractID,1),size(betas,1));
        for i=1:1:numNests
            [SharesWithinTimesUtilVarByTractNest] = getSharesTimesUtilVarByTractOP(1*(ts.nests==i).*ts_shares./(nestProb(ts.tractID+(i-1)*max(ts.tractID))+1*(ts.nests~=i)), ts);
            SharesWithinTimesUtilVarByTractNestRelevant=SharesWithinTimesUtilVarByTractNestRelevant+SharesWithinTimesUtilVarByTractNest.*(repmat(ts.nests,1,size(betas,1))==i);
        end;
        
        
        % Function that calculated derivative of the objective function
        [derUtilVar] = gradObjOPalphadensityNests(SharesTimesUtilVarByTract, SharesWithinTimesUtilVarByTractNestRelevant, ts_shares, ts,   storeRevenue,rev_hat, alpha, lambda, u, sumUexpul, sumexpul, nestProb );
        grad=derUtilVar;
    end
    
    %For some reason, we need this here so that the standard output buffer
    %is flushed and we see the iterative output by KNITRO using MATLAB
    %r2016a, it's annoying but I don't have a better option right now.
    fprintf('.');
end

