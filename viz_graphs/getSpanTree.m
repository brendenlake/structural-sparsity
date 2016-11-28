% Get the max spanning tree
% for the edge weights
%
% Input
%  M: graph in adj format
%  tag: node names
%
% Output
%   W_layout: [n x n logical] these
%     edges belong to the tree
function W_layout = getSpanTree(M,tag)
    Wtree_inv = zeros(size(M.W_allowed));
    Wtree_inv(M.W_allowed) = 1./(M.W(M.W_allowed))+eps;
    bgtree = biograph(Wtree_inv,tag);
    dolayout(bgtree);
    treeS = minspantree(bgtree);
    tree = full(treeS);
    tree = tree+tree';
    W_layout = tree>eps;
end