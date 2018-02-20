function [derUtilVar ] = gradObjOPalphadensityNests(SharesTimesUtilVarByTract, SharesWithinTimesUtilVarByTractNest, shares, ts, storeRevenue,rev_hat, alpha, lambda, u, sumUexpul, sumexpul, nestProb )
%   This function constructs the derivative of the objective function. 
%   ContractedForLambda(i,j) - Derivative of the store i revenue with
%   respect to lambda_j (variable which governs correlation in the nest j)
%   ContractedForUtilVar(i,j) - Derivative of store i revenue with respect to util Var j 
%   twoTimesRevenueDifference - Derivative of objective function with respect to rev_hat.


    numStores=max(ts.storeID);
    numChains=max(ts.chainID);
    numChainsC=max(ts.chainIDC);
    numNests=max(ts.nests);
    
    % Derivative of the objective function with respect to store revenue
    twoTimesRevenueDifference=2*((log(rev_hat)- log(storeRevenue))./rev_hat);

    numUtilVar=size(ts.utilVar,2);
    ContractedForUtilVar=zeros(numStores,numUtilVar);
    derUtilVarExtended=zeros(numUtilVar,1);
    
    
    for i=1:1:numUtilVar
        ContractedForUtilVar(:,i)=accumarray(ts.storeID,ts.inc.*ts.pop.*(((1./lambda(ts.nests)).*shares.*ts.utilVar(:,i)-shares.*SharesTimesUtilVarByTract(:,i))+shares.*(1-(1./lambda(ts.nests))).*SharesWithinTimesUtilVarByTractNest(:,i)));
        
        derUtilVarExtended(i,1)=ContractedForUtilVar(:,i)'*twoTimesRevenueDifference;
        
    end;
    
    
    
    StoreNest=repmat(ts.nests,1,numNests);
    NestNumber=repmat(1:1:numNests,size(ts.tractID,1),1);
    indexes=repmat(ts.tractID,1,numNests)+(NestNumber-1)*max(ts.tractID);
    Strsumexpul=sumexpul(indexes);
    StrsumUexpul=sumUexpul(indexes);
    NestNumberProb=nestProb(indexes);
    
    forLambdaDer=repmat(shares,1,numNests).*(1*(StoreNest==NestNumber)-NestNumberProb).*(log(1*(Strsumexpul==0)+Strsumexpul) - (StrsumUexpul./((lambda(NestNumber).*(1*(Strsumexpul==0)+Strsumexpul)))) ) - repmat(shares,1,numNests).*(1*(StoreNest==NestNumber)).*(1./(lambda(StoreNest).^2)).*(repmat(u,1,numNests)-(StrsumUexpul./(1*(Strsumexpul==0)+Strsumexpul)));
    
    ContractedForLambda=zeros(numStores,numNests);
    derLambdaExtended=zeros(numNests,1);
    
    
    for i=1:1:numNests
        ContractedForLambda(:,i)=accumarray(ts.storeID,alpha*ts.inc.*ts.pop.*forLambdaDer(:,i));
        derLambdaExtended(i,1)=ContractedForLambda(:,i)'*twoTimesRevenueDifference;
        
    end;
    
 
    % Derivative of the store revenue with respect to variables in the
    % outside option
    sharestimesdensity=getSharesTimesdensity(ts, shares, alpha);
    derUtilVar=[alpha*derUtilVarExtended;derLambdaExtended;sharestimesdensity'*twoTimesRevenueDifference;twoTimesRevenueDifference'*rev_hat/alpha];
    
    
end

