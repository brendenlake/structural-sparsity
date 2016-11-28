% Visualize the MAP dataset
% while over-layed on the best 2D space
function G = setStyleMap(G,M)
  
    X = [ -3.6000    6.7667
       -0.1166   -1.4046
        3.7729    0.5496
        3.9257    6.0947
       -3.8066    0.3079
        0.0626    5.6604
        3.0834   -5.4861
        0.3166   -6.3749
       -3.6291   -6.1120];
    Xobs = X;

    % Rotate -90 degrees
    rot = [0 1; -1 0];
    Xobs = rot * Xobs';
    Xobs = Xobs';

    obs = ~M.isclust;
    nobs = sum(obs);
    clust = ~obs;
    nclust = sum(clust);

    Xclust = zeros(nclust,2);
    noattach = false(nclust,1);
    for c=1:nclust
       cindx = c+nobs;
       attach = M.W_allowed(cindx,obs);
       if sum(attach)==1
          Xclust(c,:) = Xobs(attach,:);
       elseif sum(attach)>1
          Xclust(c,:) = mean(Xobs(attach,:)); 
       else
          noattach(c) = true;
       end
    end

    G.XY(obs,:) = Xobs;
    G.XY(clust,:) = Xclust;
    G = setGraph(G,'fontsize',18);
    G = setGraphEdges(G,G.tag,G.tag,'color',[.5 .5 .5]);
end