%   Plot the senate graph, but
%   show only a subset of the object node
%
function GS = make_senate_subgraph(G,names_sub,keep_red,keep_blue)

    % Definition of edge colors
    bg = .25;
    dem_color = [bg bg 1];
    repub_color = [1 bg bg];
    middle_color = [.75 .75*bg .75];
    fontsize = 10; % font size of names
    
    load('senate111','bool_dem');
    bool_dem = bool_dem(:);
    ns = length(bool_dem);

    obs = 1:ns;
    ntot = numel(G.tag);
    clust = ns+1:ntot;
    nclust = numel(clust);
    bool_obs = false(ntot,1);
    bool_obs(obs)= true;
    
    % Label the cluster nodes also as "blue" or "red"
    blueNode = [bool_dem; false(nclust,1)];
    for c=clust
       rowAdj = G.adj(c,obs);
       if mean(blueNode(rowAdj)) > .5
          blueNode(c) = true; 
       end
    end
    
    % Remove all objects except for a subset
    toKeep = true(size(G.tag));
    for i=1:length(obs)
        sname = G.tag{i};
        if any(strcmp(sname,names_sub))
            toKeep(i) = true;
        else
            toKeep(i) = false;
        end
    end
    if ~keep_red % remove GOP
       toKeep = toKeep & blueNode; 
    end
    if ~keep_blue % remove DEMS
       toKeep = toKeep & ~blueNode; 
    end
    
    % Create new graph
    GS = createGraph(G.adj(toKeep,toKeep),G.tag(toKeep));
    blueNode = blueNode(toKeep);
    bObsNew = bool_obs & toKeep;
    bHidNew = ~bool_obs & toKeep;    
    GS = setGraphNodes(GS,G.tag(bObsNew),'size',1);
    GS = setGraphNodes(GS,G.tag(bHidNew),'size',10,...
        'showLabel',false,'color',[.35 .35 .35]);
    GS = setGraph(GS,'fontsize',fontsize);
    GS.XY = G.XY(toKeep,:);
          
    % Set the edge colors
    GS = setGraphEdges(GS,GS.tag(blueNode),GS.tag(blueNode),'color',dem_color);
    GS = setGraphEdges(GS,GS.tag(~blueNode),GS.tag(~blueNode),'color',repub_color);
    GS = setGraphEdges(GS,GS.tag(~blueNode),GS.tag(blueNode),'color',middle_color);
    
end