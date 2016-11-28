function G = setStyleHuge(G)
    G = setGraph(G,'fontsize',12);
    bg = .7; % brightness
    G = setGraphEdges(G,G.tag,G.tag,'color',[bg bg bg]);
end