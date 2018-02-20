function [rev] = getRevOPalpha(ts, ts_share, alpha)
        
    % Function that calculates revenues of the stores based on their shares
    % and budget parameter alpha
    
    % Firstly the revenue which store gets from all tracts are calculated
    ts_rev = alpha*ts.inc.*ts_share.*ts.pop;
    
    % Revenues from all nearby tracts are sumed for the store
    rev = accumarray(ts.storeID,ts_rev);

end