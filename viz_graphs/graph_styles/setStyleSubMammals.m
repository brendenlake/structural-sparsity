% Plot just a subset of the mammals
%
% Input
%  G: input graph
%  M: model structure
%
% Output
%  GS: output graph
function GS = setStyleSubMammals(G,M)

    font_size = 18;
    names_sub = {'dolphin';
    'seal';
    'gorilla';
    'squirrel';
    'mouse';
    'chimpanzee';
    'cow';
    'rhinoceros';
    'elephant';
    'horse'};

    hid = M.isclust;
    nclust = sum(hid);
    obs = ~M.isclust;
    nobs = sum(obs);
    ntot = length(M.isclust);
    
    nsub = length(names_sub);
    obs_sub = false(nobs,1);
    tag_sub = false(ntot,1);
    for i=1:nsub
        indx = strcmp(names_sub{i},G.tag);
        assert(sum(indx)==1);
        obs_sub(indx(1:nobs)) = true;
        tag_sub(indx) = true;
    end
    indx_sub = find(tag_sub);
    
    % Get the lengths of each edge
    Len = zeros(size(M.W));
    Len(M.W_allowed) = 1./(M.W(M.W_allowed));
    paths = cell(nsub,1);
    for i=1:nsub        
        [dist, path] = graphshortestpath(sparse(Len),indx_sub(i));
        paths{i} = path(tag_sub);
    end
    
    % Get the overall subgraph
    subAdj = false(ntot);
    for i=1:nsub
       for j=1:nsub
           this_path = paths{i}{j};
           nlen = length(this_path);
           for k=1:nlen-1
               n1 = this_path(k);
               n2 = this_path(k+1);
               subAdj(n1,n2) = true;
               subAdj(n2,n1) = true;
           end
       end
    end
    rowSum = sum(subAdj,1);
    toDelete = rowSum==0;
    toKeep = ~toDelete;
    subAdj = subAdj(toKeep,toKeep);
    tagNew = G.tag;
    tagNew(toDelete) = [];
    obsNew = false(length(tagNew),1);
    obsNew(1:nsub) = true;
    
    % Make the new graph
    GS = createGraph(subAdj,tagNew);
    GS = setGraphNodes(GS,tagNew(obsNew),'size',1,'color',[1 1 1]);
    GS = setGraphNodes(GS,tagNew(~obsNew),'showLabel',false);
    GS = setGraph(GS,'fontsize',font_size);
    GS.XY = G.XY(toKeep,:);
end