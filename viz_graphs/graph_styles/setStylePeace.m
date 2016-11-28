function G = setStylePeace(G,M)
    
    % Get variable information
    obs = ~M.isclust;
    hid = M.isclust;
    ntot = length(G.tag);
    
    % Use synthetic style
    G = setStyleSynthetic(G,obs);
    
    
    center = ntot;
    old_center = G.XY(center,:);
    other_hid = hid;
    other_hid(center) = false;
    attach_center = M.W_allowed(obs,center);
    
    % Get the new center coordinates
    G.XY(center,:) = mean(G.XY(other_hid,:));
    
    % For each attachment to center, readjust coordinates
    find_attach_center = find(attach_center);
    for i=1:numel(find_attach_center);
        G.XY(find_attach_center(i),:) = (G.XY(find_attach_center(i),:) - old_center) + G.XY(center,:);
    end
    
end