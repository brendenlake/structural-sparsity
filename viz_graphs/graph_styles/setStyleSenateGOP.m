%   Plot just the names of the GOP
function GS = setStyleSenateGOP(G)
    load('senate111','bool_dem');
    bool_dem = bool_dem(:);
    ns = length(bool_dem);
    obs = 1:ns;
    names = G.tag(obs);
    names_sub = names(~bool_dem);
    GS = make_senate_subgraph(G,names_sub,true,false);    
end