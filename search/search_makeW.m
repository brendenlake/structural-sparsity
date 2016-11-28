% Extract the overall weight matrix
%
% Output
%   W: [ntot x ntot] weight matrix
%   W_allowed: [ntot x ntot] sparsity pattern
%   isclust: [ntot x 1 boolean] is this a cluster node?
%   sigma: [scalar] diagonal term
function [W,W_allowed,isclust,sigma] = search_makeW(M)

    % Node information
    nclust = size(M.WK,1);
    nobs = M.nobs;
    isclust = search_get_clust(M);
    
    % Observed to observed portion
    W_allowed_oo = false(nobs);
    W_oo = zeros(nobs);
    
    % Observed to cluster portion
    W_allowed_oc = false(nobs,nclust);
    W_oc = zeros(nobs,nclust);
    for o=1:nobs
       c = M.ci(o);
       W_allowed_oc(o,c) = true;
       W_oc(o,c) = M.wi(o);
    end
    
    % Cluster to cluster portion
    W_allowed_cc = M.SK;
    W_cc = M.WK;
    
    % Aggregate the components
    W_allowed = [W_allowed_oo W_allowed_oc; W_allowed_oc' W_allowed_cc];
    W = [W_oo W_oc; W_oc' W_cc];
    sigma = M.sigma;
end