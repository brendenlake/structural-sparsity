%
% Input
%  G: input graph
%  W_tree: [n x n logical] which edges are in the tree?
%    we want to make non-tree edges another style
%
% Output
%  G: output graph
function G = setStyleMammals(G,W_tree)
    G = setStyleAnimals(G,W_tree);
    G = setGraphEdges(G,G.tag,G.tag,'color',[.5 .5 .5]);
end