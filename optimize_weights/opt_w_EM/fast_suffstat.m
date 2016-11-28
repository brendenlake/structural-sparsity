% Compute the sufficient statistics for the completed data set.
%
% Input
%   E: [ntot x ntot] current estimate of covariance matrix
%   given: [ntot x m] data matrix with miss entries (denoted inf)
%   miss_info: information about missing data (see function missingpat) 
% 
% Output
%   E_extend: [ntot x ntot] estimate of sufficient statistics
function E_extend = fast_suffstat(E,given,miss_info)
    [n,m] = size(given);
    [inf_mean,inf_var]=blockGaussInf(zeros(n,1),E,given,miss_info);
    data_fill = given;
    missing = isinf(given);
    data_fill(missing) = inf_mean(missing);
    S = m*calc_cov(data_fill);
    nunique_miss = size(miss_info.pat,2); % number of unique missing data patterns
    for u=1:nunique_miss
       miss = ~miss_info.pat(:,u);
       sel_miss = miss_info.indx==u;
       S(miss,miss) = S(miss,miss) + sum(inf_var(miss,miss,sel_miss),3);
    end
    E_extend = S./m;
    assert(~any(isinf(E_extend(:))));
    assert(~any(isnan(E_extend(:))));
end