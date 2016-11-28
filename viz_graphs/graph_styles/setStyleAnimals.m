% Plot underlying spanning tree
%
% Input
%  G: input graph
%  W_tree: [n x n logical] which edges are in the tree?
%    we want to make non-tree edges another style
%  M: model format
%
% Output
%  G: output graph
function G = setStyleAnimals(G,W_tree,M)
    
    sz_clust  = 20; % size of cluster nodes
    bg_node = .55; % color of cluster nodes (lower is darker)
    bg_edge = .25; % color of exception edge
    col_clust = [bg_node bg_node bg_node];

    % Mark exception edges
    nontree_color = [bg_edge bg_edge bg_edge];
    nontree_style = '--';
    bend = false;
    toMark = ~W_tree & G.adj;
    G = markEdges(G,toMark,nontree_color,nontree_style,bend);
    
    % Adjust node size for cluster nodes with 
    % attached objects
    obs = ~M.isclust;
    nobs = sum(obs);
    hid = ~obs;
    C = G.adj(obs,hid);
    [row,col] = find(C);
    level1_clust = col+nobs;
    G = setGraphNodes(G,G.tag(level1_clust),'size',sz_clust,'color',col_clust);
    G = setGraph(G,'fontsize',15);
    
end