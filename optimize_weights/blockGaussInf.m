% Inference for missing data. Computed efficiently by blocking
% the pattern of missing values for each feature.
%
% Input
%   mu: mean of Gaussian
%   given: rows are objects, columns features [n x m]. Missing values are inf
%   E: covariance matrix of model
%   miss_info: pattern of missing data (see function missingpat)
%
%
% Output
%   mu_bar: [n x m] matrix of expected values. All corresponding entries
%       in "given" that were observed are NaN. Entries that were inf in
%       given are replaced with expected value.
%   sig_bar: [n x n x m] covariance matrix of missing data. For each
%       feature i (1..m), only calculates covariance term for two
%       missing variables. Other entries are NaN.
function [mu_bar,sig_bar]=blockGaussInf(mu,E,given,miss_info)

    if ~exist('miss_info','var')
        miss_info = missingpat(given);
        fprintf(1,'Warning: Block Gaussian inference did not cache\n');
    end

    mu = mu(:);
    assert(numel(mu)==size(E,1));
    [n,m] = size(given);
    mu_bar = nan(n,m);
    sig_bar = nan(n,n,m);
    mx = max(miss_info.indx);
    for i=1:mx
        sel = miss_info.indx==i;
        nsel = sum(sel);
        pi = miss_info.pat(:,i);
        miss = ~pi;
        dsub = given(:,sel);
        [mbar,sbar] = gaussian_inference_mat(mu,E,dsub);
        mu_bar(miss,sel) = mbar;
        sig_bar(miss,miss,sel) = repmat(sbar,[1 1 nsel]);
    end
    
    if any(isinf(mu_bar(:)))
        error('Missing pattern on input is wrong'); 
    end
end