%
% Input
%  G: input graph
%
% Output
%  G: output graph
function G = setStyleJudges(G,M)

    hid = M.isclust;
    nclust = sum(hid);
    obs = ~M.isclust;
    nobs = sum(obs);
    
    % Adjust the lengths of the object connections
    clustLen = zeros(nobs,1);
    for o=1:nobs
        clustLen(o) = max(M.W(o,:));
    end
    clustLen = 1./clustLen;
    clustLen = clustLen ./ max(clustLen);
    G.XY(obs,2) = G.XY(obs,2) .* clustLen;
    
    % Highlight exceptions to the 1D structure
    X = G.XY(hid,1);
    order_ltr = zeros(nclust,1);
    for i=1:nclust
        order_ltr(i) = argmin(X);
        X(order_ltr(i)) = inf;
    end
    
    lineAdj = false(nclust);
    for i=1:nclust-1
        oleft = order_ltr(i);
        oright = order_ltr(i+1);
        lineAdj(oleft,oright) = true;
    end
    lineAdj = logical(lineAdj+lineAdj');    
    
          
    toMark = ~lineAdj & M.W_allowed(M.isclust,M.isclust);
    toMark = [false(nobs) false(nobs,nclust); ...
                false(nclust,nobs) toMark];        

    mark_color = [0 0 0];
    mark_style = '--';
    bend = true;
    G = markEdges(G,toMark,mark_color,mark_style,bend);
    G = setGraphNodes(G,G.tag(hid),'size',1,'color',[0 0 0]);
    % G = setGraphNodes(G,G.tag(hid),'size',30,'color',[.5 .5 .5]);
    G = setGraph(G,'fontsize',26);
end