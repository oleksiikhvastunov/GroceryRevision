function [ structure ] = getStructureOPNests( params, ts )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% Unpack the parameter vector into lambda, beta, and tau. 
    %numChains = max(ts.chainID);
    %numChainsC = max(ts.chainIDC);
    %numStores = max(ts.storeID);
    %Check that the parameter vector is the correct length:
    %assert(length(params)==(2*(numChainsC-1)+12+6));
    %lambdas=[params(1:2);params(end-3:end)];
    % interaction terms are added at the end
    %betas=[params(3:4,1);0;params(5:5+numChainsC-2);0;params(5+numChainsC-1:end-4)];
    
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
    structure = getRevOPalphaStructureNests(ts, ts_shares, alpha); 
    
    
end

