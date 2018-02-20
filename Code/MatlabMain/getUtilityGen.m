function [ u ] = getUtilityGen( ts, beta )
%getUtilityGen: Computes the utility of each store in each tract 
% u is indexed by store-tract pairs where store is ts.storeID and tract is
% ts.tractID

    u = ts.utilVar*beta;
    
end

