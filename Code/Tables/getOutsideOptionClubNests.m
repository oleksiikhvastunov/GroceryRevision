function [ OutsideOptionStructure ] = getOutsideOptionClubNests( params,ts )

    numNests=max(ts.nests);
    betas=params(1:end-3-numNests);
    lambda=params(end-3-numNests+1:end-3);
    aalpha=params(end-2:end-1);
    alpha=params(end);
    numNests=max(ts.nests);
    cd ../MatlabMain
    u = getUtilityGen(ts, betas); 
    [ts_shares, nestProb, sumUexpul, sumexpul] = getShareGenOPdensity3Nests(ts,u,aalpha,lambda);
    cd ../Tables
    
    inopt=accumarray(ts.tractID,ts_shares);
    OutsideOption=1-inopt;
    OutsideOptionStructure=OutsideOption(ts.tractID);

end

