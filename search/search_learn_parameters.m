% Update the parameters with their maximum-likelihood values.
% DO NOT change the sparsity pattern.
%
% Input
%   M: model in search format
%
% Output
%   M: model with updated parameters
function M = search_learn_parameters(M)
    [W0,W_allowed,isclust,sigma0] = search_makeW(M);
    [WF,sigmaF] = optimize_weights(M.data,W0,sigma0,W_allowed,isclust,M.miss_info);
    M = search_inv_makeW(M,WF,W_allowed,sigmaF);
end