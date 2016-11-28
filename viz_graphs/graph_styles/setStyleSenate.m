function G = setStyleSenate(G)
    
    % Definition of edge colors
    dem_color = [0 0 1];
    repub_color = [1 0 0];
    middle_color = [.5 0 .5];
    
    load('senate111','bool_dem');
    bool_dem = bool_dem(:);
    ns = length(bool_dem);

    obs = 1:ns;
    clust = ns+1:numel(G.tag);
    nclust = numel(clust);
    
    % Label the cluster nodes also as "blue" or "red"
    blueNode = [bool_dem; false(nclust,1)];
    for c=clust
       rowAdj = G.adj(c,obs);
       if mean(blueNode(rowAdj)) > .5
          blueNode(c) = true; 
       end
    end    
    
    % Set the edge colors
    G = setGraphEdges(G,G.tag(blueNode),G.tag(blueNode),'color',dem_color);
    G = setGraphEdges(G,G.tag(~blueNode),G.tag(~blueNode),'color',repub_color);
    G = setGraphEdges(G,G.tag(~blueNode),G.tag(blueNode),'color',middle_color);

%     tag_obs = G.tag(1:ns);   
%     G = setGraphNodes(G,tag_obs(bool_dem),'colorLabel',dem_color);  
%     G = setGraphNodes(G,tag_obs(~bool_dem),'colorLabel',repub_color);
end