% Which nodes are latent clusters?
%
% Output
%   isclust: [ntot x 1 boolean] is this a cluster node?
function isclust = search_get_clust(M)
    nclust = size(M.WK,1);
    nobs = M.nobs;
    ntot = nclust + nobs;
    isclust = true(ntot,1);
    isclust(1:nobs) = false;
end