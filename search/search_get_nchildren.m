% Get the number of children for each latent cluster.
%
% Output
%   nchildren: [nclust x 1] child count
function nchildren = search_get_nchildren(M)
    nclust = max(M.ci);
    assert(nclust==size(M.WK,1));
    nchildren = zeros(nclust,1);
    for c=1:nclust
       nchildren(c) = sum(M.ci==c); 
    end
end