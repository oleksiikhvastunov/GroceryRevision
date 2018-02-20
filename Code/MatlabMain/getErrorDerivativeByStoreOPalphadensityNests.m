function [derErrorByStore] = getErrorDerivativeByStoreOPalphadensityNests(SharesTimesUtilVarByTract, SharesWithinTimesUtilVarByTractNest, shares, ts, storeRevenue,rev_hat,alpha, lambda, u, sumUexpul, sumexpul, nestProb)

    numStores=max(ts.storeID);
    numChains=max(ts.chainID);
    numChainsC=max(ts.chainIDC);
    numNests=max(ts.nests);
    numUtilVar=size(ts.utilVar,2);
    
    % derivative of the objective function with respect to revenue of the stores	
    twoTimesRevenueDifference=2*((log(rev_hat)- log(storeRevenue))./rev_hat);
    

    numUtilVar=size(ts.utilVar,2);
    
    
    % derivative of revenue of the stores with respect to utility variables
    ContractedForUtilVar=zeros(numStores,numUtilVar);
    % derivative of the objective function with respect utility variables	
    forUtilVar=zeros(numStores,numUtilVar);
    [fordensityvar]=getSharesTimesdensity(ts, shares, alpha);
    
    for i=1:1:numUtilVar
        ContractedForUtilVar(:,i)=accumarray(ts.storeID,ts.inc.*ts.pop.*(((1./lambda(ts.nests)).*shares.*ts.utilVar(:,i)-shares.*SharesTimesUtilVarByTract(:,i))+shares.*(1-(1./lambda(ts.nests))).*SharesWithinTimesUtilVarByTractNest(:,i)));
        % derivative of the contribution of each stores to the objective function with respect to utility variables (has number of stores rows and number of utility variables columns) and is used to calculate variance covariance matrix as an outer products of gradients 
        forUtilVar(:,i)=ContractedForUtilVar(:,i)'.*twoTimesRevenueDifference';
        
    end;
    
    StoreNest=repmat(ts.nests,1,numNests);
    NestNumber=repmat(1:1:numNests,size(ts.tractID,1),1);
    indexes=repmat(ts.tractID,1,numNests)+(NestNumber-1)*max(ts.tractID);
    Strsumexpul=sumexpul(indexes);
    StrsumUexpul=sumUexpul(indexes);
    NestNumberProb=nestProb(indexes);
    
    forLambdaDer=repmat(shares,1,numNests).*(1*(StoreNest==NestNumber)-NestNumberProb).*(log(1*(Strsumexpul==0)+Strsumexpul) - (StrsumUexpul./((lambda(NestNumber).*(1*(Strsumexpul==0)+Strsumexpul)))) ) - repmat(shares,1,numNests).*(1*(StoreNest==NestNumber)).*(1./(lambda(StoreNest).^2)).*(repmat(u,1,numNests)-(StrsumUexpul./(1*(Strsumexpul==0)+Strsumexpul)));
    
    ContractedForLambda=zeros(numStores,numNests);
    forLambda=zeros(numStores,numNests);
    
    
    
    for i=1:1:numNests
        ContractedForLambda(:,i)=accumarray(ts.storeID,alpha*ts.inc.*ts.pop.*forLambdaDer(:,i));
        forLambda(:,i)=ContractedForLambda(:,i)'.*twoTimesRevenueDifference';
        
    end;
    
    derErrorByStore=[forUtilVar';forLambda';repmat(twoTimesRevenueDifference',2,1).*fordensityvar';twoTimesRevenueDifference'.*rev_hat'/alpha];
    
end

