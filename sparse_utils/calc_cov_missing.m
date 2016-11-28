% Estimate the raw covariance matrix with missing data.
% This is done by running EM with positivity constraints
% on a fully connected graph.
%
% Input
%   data: [n x m real] data matrix
%      entries that are "inf" are missing
%
% Output
%   Y: n x n covariance matrix estimate
function Y = calc_cov_missing(data)    
    has_missing = any(isinf(data(:)));
    if ~has_missing
       Y = calc_cov(data); 
       return
    end
    Y = calc_cov_missing_em(data);
end

% Handle case where two objects share no features.
function Y = calc_cov_missing_em(data)
    
    [n,m] = size(data);
    
    % Set up parameters where all weights are allowed
    W0 = zeros(n);
    diag = logical(eye(n));
    W_allowed = ~diag;
    sigma0 = 1;
    isclust = false(n,1);
    miss_info = missingpat(data);
    
    % Run EM
    [WF,sigmaF] = optimize_weights(data,W0,sigma0,W_allowed,isclust,miss_info);

    % Get the covariance matrix
    S = laplacian(WF,sigmaF);
    Y = inv_posdef(S);
end