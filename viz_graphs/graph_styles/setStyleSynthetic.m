function G = setStyleSynthetic(G,obs)
    G = setGraphNodes(G,G.tag(obs),'size',25,'color',[0 0 0]);
    G = setGraphNodes(G,G.tag(~obs),'size',20,'color',[.5 .5 .5]);
    G = setGraphNodes(G,G.tag,'showLabel',false);
end