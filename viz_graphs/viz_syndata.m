% Visualize the synthetic datasets
syn_data = {'synth_ring','synth_grid'...
    'synth_ring_multi','synth_grid_multi',...
    'synth_ring_tree'};
nd = length(syn_data);
for i=1:nd
   file = syn_data{i};
   load(file,'X','names');
   displayS(X,names,'style','synth');
   set(gcf,'OuterPosition',[100 100 333 372]);
   pdf_gcf([file,'.pdf']);
end
 
% CLUSTERS
file = 'synth_clust';
load(file,'X','names');
WALayout = X.W_allowed;
SK = ring_graph(4);
WALayout(X.isclust,X.isclust) = SK;
X.W(X.isclust,X.isclust) = 2;
displayS(X,names,'style','synth','layout_edges',WALayout);
set(gcf,'OuterPosition',[100 100 333 372]);
pdf_gcf([file,'.pdf']);

% MULTI CHAIN
file = 'synth_chain_multi';
load(file,'X','names');
ring_wt = 1.5; % strength of pull for beginning and end in plot
WALayout = X.W_allowed;
SK = WALayout(X.isclust,X.isclust);
t1 = [9 10 11];
SK(1,t1) = true; SK(t1,1) = true;
t2 = [5 6 7];
SK(end,t2) = true; SK(t2,end) = true;
WALayout(X.isclust,X.isclust) = SK;
WK = X.W(X.isclust,X.isclust);
WK(WK<.01) = ring_wt;
X.W(X.isclust,X.isclust) = WK;
displayS(X,names,'style','synth','layout_edges',WALayout);
set(gcf,'OuterPosition',[100 100 333 372]);
pdf_gcf([file,'.pdf']);

% SINGLE CHAIN
file = 'synth_chain';
load(file,'X','names');
WALayout = X.W_allowed;
WALayout(X.isclust,X.isclust) = SK;
WK = X.W(X.isclust,X.isclust);
WK(1,end) = ring_wt; WK(end,1) = ring_wt;
X.W(X.isclust,X.isclust) = WK;
displayS(X,names,'style','synth','layout_edges',WALayout);
set(gcf,'OuterPosition',[100 100 333 372]);
pdf_gcf([file,'.pdf']);

% MULTI PEACE
file = 'synth_peace_multi';
load(file,'X','names');
W_layout = X.W_allowed;
W_layout(end,X.isclust) = false;
W_layout(X.isclust,end) = false;
displayS(X,names,'style','peace','layout_edges',W_layout);
set(gcf,'OuterPosition',[100 100 333 372]);
pdf_gcf([file,'.pdf']);

% SINGLE PEACE
file = 'synth_peace';
load(file,'X','names');
W_layout = X.W_allowed;
W_layout(end,X.isclust) = false;
W_layout(X.isclust,end) = false;
displayS(X,names,'style','peace','layout_edges',W_layout);
set(gcf,'OuterPosition',[100 100 333 372]);
pdf_gcf([file,'.pdf']);

TREE
file = 'synth_tree';
load(file,'X','names');
displayS(X,names,'style','synth');
set(gcf,'OuterPosition',[100 100 333 372]);
pdf_gcf([file,'.pdf']);

% MULTI PLANE GRAPH
file = 'synth_plane_multi';
load(file,'X','names');
mini_grid = grid_graph(16);
LayoutPlane = X.W_allowed;
LayoutPlane(X.isclust,X.isclust) = mini_grid;
X.W(X.isclust,X.isclust) = max(vec(X.W(X.isclust,X.isclust)));
displayS(X,X.names,'style','synth','layout_edges',LayoutPlane);
set(gcf,'OuterPosition',[100 100 333 372]);
pdf_gcf([file,'.pdf']);

% DISCONNECTED CHAINS
file = 'synth_chain_split_multi';
load(file,'X','names');
clust_wt = 1; % strength of pull for beginning and end in plot
WALayout = X.W_allowed;
SK = WALayout(X.isclust,X.isclust);
SK(1,6) = true;
SK(3,8) = true;
SK(5,10) = true; 
SK(1,11) = true;
SK(3,14) = true;
SK(5,end-1) = true;
SK = logical(SK+SK');
WALayout(X.isclust,X.isclust) = SK;
WK = X.W(X.isclust,X.isclust);
WK(WK<.01) = clust_wt;
X.W(X.isclust,X.isclust) = WK;
displayS(X,names,'style','synth','layout_edges',WALayout);
set(gcf,'OuterPosition',[100 100 333 372]);
pdf_gcf([file,'.pdf']);