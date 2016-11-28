%   Plot just the backbone of the senate graph.
% 
%   This includes all of the cluster nodes,
%   and just a handful of the observed nodes.
function GS = setStyleSenateBackbone(G)
    names_sub = {'Nelson','Bayh','Lincoln','Snowe','Collins','Murkowski','Feingold','Mccaskill'};
    GS = make_senate_subgraph(G,names_sub,true,true);    
end