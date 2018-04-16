function [ts_rev] = getRevOPalphaStructureNests(ts, ts_share, alpha)

    ts_rev = alpha*ts.inc.*ts_share.*ts.pop;
    

end