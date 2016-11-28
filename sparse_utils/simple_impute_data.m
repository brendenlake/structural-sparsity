% Simple data imputation.
% (1) Run EM with a fully connected Gaussian with positive weights
% (2) Infer the means of the missing entries with inference
% 
% Input
%   data: [n x m real] data matrix
%      entries that are "inf" are missing
%
% Output
%   data: [n x m real] data matrix with no missing entries
function data = simple_impute_data(data)
    [n,m] = size(data);
    is_missing = isinf(data);
    if ~any(is_missing(:))
       return 
    end    
    miss_info = missingpat(data);
    
    % Run EM
    Y = calc_cov_missing(data);
    
    % Do inference for the rest
    mu = zeros(n,1);
    mu_bar = blockGaussInf(mu,Y,data,miss_info);
    data(is_missing) = mu_bar(is_missing);
    assert(~any(isinf(data(:))) && ~any(isnan(data(:))));
end