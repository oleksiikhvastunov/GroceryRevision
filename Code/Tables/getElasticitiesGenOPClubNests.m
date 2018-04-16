function [ distanceEf, incomeEf, wealthEf, substEf] = getElasticitiesGenOPClubNests( params, ts)
    numNests=max(ts.nests);

    numChains = max(ts.chainID);
    numChainsC = max(ts.chainIDC);
    numNests=max(ts.nests);
    % Unpacking parameter vector
    betai=[params(end-3-numNests-numChainsC+1:end-3-numNests)];
    betas=params(1:end-3-numNests);
    lambda=params(end-3-numNests+1:end-3);
    aalpha=params(end-2:end-1);
    alpha=params(end);
    numNests=max(ts.nests);
    cd ../MatlabMain
    u = getUtilityGen(ts, betas); 
    [ts_shares, nestProb, sumUexpul, sumexpul] = getShareGenOPdensity3Nests(ts,u,aalpha,lambda); % lambda need to be a vector
    rev_hat = getRevOPalpha(ts, ts_shares, alpha);
    
    nestProbStr = nestProb(ts.tractID+(ts.nests-1)*max(ts.tractID));
    cd ../Tables
    [ OutsideOptionStructure ] = getOutsideOptionClubNests( params,ts );

    hhsize1=betas(2,1);
    dist1=betas(4,1);
    logsize1=betas(6,1);
    logfte1=betas(8,1);
    logchk1=betas(10,1);
    logsizeC=betas(12,1);
    distC=betas(14,1);
    
    numChainsG=numChainsC-3;
    
       
    
    % Mapping for StoreID to ChainID
    storeChainMap=unique([ts.storeID,ts.chainIDC],'rows');
    
    
    revenueTractStore=alpha.*ts.inc.*ts.pop.*ts_shares;
    chainRevenue=accumarray(ts.chainIDC,revenueTractStore);
    
    % Calculating distance elasticity for the store-chain pair
    elastTractStoreDist=(1./lambda(ts.nests)-ts_shares+(1-1./lambda(ts.nests)).*(ts_shares./nestProbStr)).*((ts.chainIDC<(numChainsG+1)).*(ts.utilVar(:,3))+(ts.chainIDC>numChainsG).*(ts.utilVar(:,13))).*((ts.chainIDC<(numChainsG+1)).*(betas(3,1)+betas(4,1)*ts.logInc)+(ts.chainIDC>numChainsG).*(betas(13,1)+betas(14,1)*ts.logInc));
    % Calculating store level distance elacticity by weighening it using
    % revenue from nearby tracts
    elastStoreDist=accumarray(ts.storeID,elastTractStoreDist.*revenueTractStore)./rev_hat;
    % Calculating distance elasticity for the Chain
    elastChainDist=accumarray(storeChainMap(:,2),elastStoreDist.*rev_hat)./chainRevenue;
    
    distanceEf=elastChainDist;
    cd ../MatlabMain
    [SharesTimesUtilVarByTract] = getSharesTimesUtilVarByTractOP(ts_shares, ts);
        
    SharesWithinTimesUtilVarByTractNestRelevant=zeros(size(ts.tractID,1),size(betas,1));
    for i=1:1:numNests
        [SharesWithinTimesUtilVarByTractNest] = getSharesTimesUtilVarByTractOP(1*(ts.nests==i).*ts_shares./(nestProb(ts.tractID+(i-1)*max(ts.tractID))+1*(ts.nests~=i)), ts);
        SharesWithinTimesUtilVarByTractNestRelevant=SharesWithinTimesUtilVarByTractNestRelevant+SharesWithinTimesUtilVarByTractNest.*(repmat(ts.nests,1,size(betas,1))==i);
    end;
    
    % 1- beta_{hi} p_{0t} hhsize_t, minus sign is because in the code
    % beta_{hi} is in the inside goods, here is it moved to outside good
    % Wealth effect for the store-tract pair
    elastTractStoreWealthEf=1-(-1*hhsize1)*OutsideOptionStructure.*ts.utilVar(:,1);
    % Wealth effect on the store level
    elastStoreWealthEf=accumarray(ts.storeID,elastTractStoreWealthEf.*revenueTractStore)./rev_hat;
    % Wealth effect on the chain level
    elastChainWealthEf=accumarray(storeChainMap(:,2),elastStoreWealthEf.*rev_hat)./chainRevenue;

    wealthEf=elastChainWealthEf;
    
    sharesTimesDu=ts_shares.*(dist1*ts.utilVar(:,3)+logsize1.*ts.utilVar(:,5)+logfte1.*ts.utilVar(:,7)+logchk1.*ts.utilVar(:,9)+logsizeC.*ts.utilVar(:,11)+distC.*ts.utilVar(:,13)+betai(ts.chainIDC));
    sharesTimesDuByStore=accumarray(ts.tractID,sharesTimesDu);
    extendedSharesTimesDuByStore=sharesTimesDuByStore(ts.tractID);
    % Income effect for the store-tract pair
    elastTractStoreSubstEf=(1./lambda(ts.nests)).*(dist1*ts.utilVar(:,3)+logsize1.*ts.utilVar(:,5)+logfte1.*ts.utilVar(:,7)+logchk1.*ts.utilVar(:,9)+logsizeC.*ts.utilVar(:,11)+distC.*ts.utilVar(:,13)+betai(ts.chainIDC))-extendedSharesTimesDuByStore+(1-(1./lambda(ts.nests))).*(dist1*SharesWithinTimesUtilVarByTractNestRelevant(:,3)+logsize1.*SharesWithinTimesUtilVarByTractNestRelevant(:,5)+logfte1.*SharesWithinTimesUtilVarByTractNestRelevant(:,7)+logchk1.*SharesWithinTimesUtilVarByTractNestRelevant(:,9)+logsizeC.*SharesWithinTimesUtilVarByTractNestRelevant(:,11)+distC.*SharesWithinTimesUtilVarByTractNestRelevant(:,13)+betai(ts.chainIDC).*SharesWithinTimesUtilVarByTractNestRelevant(14+ts.chainIDC));
    % Income effect on the store level
    elastStoreSubstEf=accumarray(ts.storeID,elastTractStoreSubstEf.*revenueTractStore)./rev_hat;
    % Income effect on the chain level
    elastChainSubstEf=accumarray(storeChainMap(:,2),elastStoreSubstEf.*rev_hat)./chainRevenue;
    substEf=elastChainSubstEf;
    
    incomeEf=wealthEf+substEf;
    

    