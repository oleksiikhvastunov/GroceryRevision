function [ share, nestProb, sumUexpul, sumexpul ] = getShareGenOPdensity3Nests(ts, u, aalpha, nestlambda)
    % Function that calculats stores' shares based on their utilities u
    % aalpha is used to calculate utilities of outside option
    nestlambdastr=nestlambda(ts.nests);
    exp_ul = exp(u./nestlambdastr);
    sumUexpul = accumarray([ts.tractID,ts.nests],u.*exp_ul);
    sumexpul = accumarray([ts.tractID,ts.nests],exp_ul);
    
    
    capdensity=log(max(ts.density/1000,1));
    
    u0=aalpha(1)*capdensity+aalpha(2)*(capdensity.^2);
    % sum of exp(u)/lambda within tract and nest
    sumtractnest = accumarray([ts.tractID,ts.nests],exp_ul,[],[],[],(1==1));
    withinNestProb=exp_ul./sumtractnest(ts.tractID+(ts.nests-1)*max(ts.tractID));
    
    sumtractnestlambda = sparse(sumtractnest.^(repmat(nestlambda',max(ts.tractID),1)));
    
    sumtractnestlambdastr = sumtractnestlambda(ts.tractID+(ts.nests-1)*max(ts.tractID));
    
    %denom will be used for the denominator (sum of all exp_u within a tract);
    %ordered by tract
    denom = sum(sumtractnestlambda,2);
    denomstr = denom(ts.tractID);
    share = withinNestProb .*sumtractnestlambdastr  ./ (exp(u0)+denomstr);
    nestProb = accumarray([ts.tractID,ts.nests],full(share),[],[],[],(1==1));
    
end

