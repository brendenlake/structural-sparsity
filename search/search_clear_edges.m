% Reset the dimensionality and
% clear the weights connecting clusters to clusters.
function M = search_clear_edges(M)
    nclust = max(M.ci);
    M.WK = zeros(nclust);
    M.SK = false(nclust);
    assert(valid_search_struct(M));
end