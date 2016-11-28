% Propose merges of latent cluster nodes.
%
% Input
%  M: model
%  data_extend: [ntot x m] imputed full data matrix (w/ latent clusters)
%  sparam: search parameters
%
% Output
%  S_merges: [r x 1 cell] cell array of proposals for merging
function S_merges = search_do_merges(M,data_extend,sparam)
    
    S_merges = [];
    isclust = search_get_clust(M);
    nclust = sum(isclust);
    if nclust==1, return; end
    data_clusters = data_extend(isclust,:);
    
    % Create heuristic distance matrix
    % between clusters
    distClust = squareform(pdist(data_clusters));
    distClust = scale_dist_matrix(distClust,sparam);
    
    % Choose candidates for merging. 
    % Each latent cluster is included in one candidate pairing.
    cands = zeros(nclust,2);
    for c=1:nclust
        cands(c,:) = propose_cand(c,distClust);
    end
    cands = delete_duplicate(cands,1);
    ncands = size(cands,1);
    
    % If there are too many candidates
    if ncands > sparam.merge_max_cands
       rperm = randperm(sparam.merge_max_cands);
       cands = cands(rperm,:);        
    end
    nmerge = size(cands,1);
    
    % Try the merges
    fprintf(1,'Trying merge moves (%d of %d)\n',nmerge,ncands);
    S_merges = cell(nmerge,1);
    
    %for i=1:nmerge
    parfor i=1:nmerge
         fprintf(1,'(%d+%d',cands(i,1),cands(i,2));
         
         move = struct;
         move.type = 'merge';
         move.names1 = M.names(M.ci==cands(i,1));
         move.names2 = M.names(M.ci==cands(i,2));
         % search_describe_move(move);
         
         % search_describe_move(move);
         if ~search_tabu_legal_move(move,sparam)
            fprintf('tabu_move)');
            continue
         end
         S = do_merge(M,cands(i,:),sparam);
         
         % Record move
         assert(valid_search_struct(M));
         if ~isempty(S), S.last_move=move; end  
         S_merges{i} = S;
         fprintf(1,')');       
    end
    fprintf(1,'\n');
    
end

% Rescale the distance matrix between latent clusters,
% such that the largest element is sparam.merge_cand_temperature(2)
% and the smallest is sparam.merge_cand_temperature(1).
% The diagonal terms are set to inf.
%
% Input
%  distClust: [k x k] raw distance matrix
%  sparam: search parameters
%
% Output
%   distClust: [k x k] rescaled matrix
function distClust = scale_dist_matrix(distClust,sparam)
    
    nclust = size(distClust,1);
    if nclust==2
        distClust = [inf 0; 0 inf];
        return
    end
    diag = logical(eye(nclust));
    
    % Compute the scaling factor
    dist_vals = distClust(~diag);
    min_dist = min(dist_vals);
    dist_vals = dist_vals - min_dist;
    max_dist = max(dist_vals);
    
    % Rescale the distances
    distClust = (distClust - min_dist) ./ max_dist;
    distClust = sparam.merge_cand_temperature(2) .* distClust + sparam.merge_cand_temperature(1);
    distClust(diag) = inf;
    
    % Error checking
    if sparam.merge_cand_temperature(1) > sparam.merge_cand_temperature(2)
       error('Merge cand temperature must have x1 < x2');
    end
    if numel(nclust) > 2
        dbg = distClust(~diag);
        assert(min(dbg)==sparam.merge_cand_temperature(1) && max(dbg)==sparam.merge_cand_temperature(2));
    end
end

% Propose a merge between cluster c and another.
% This proposal is stochastic and uses the distance heuristic.
%
% Output
%  [1 x 2]: two clusters to merge (one is c)
%     where the smaller index is listed first
function prop_cand = propose_cand(c,distClust)   
    dist_opts = distClust(c,:);
    pselect = softmax(dist_opts);
    select = find(mnrnd(1,pselect));
    prop_cand = [min(c,select) max(c,select)];
end

% Merge the two nodes designated by cand.
% After the merge, redo structure learning.
function M = do_merge(M,cand,sparam)
    select_obj = M.ci == cand(1) | M.ci == cand(2);
    newC = cand(1);
    rmvC = cand(2);
    M.ci(select_obj) = newC;
    M.ci(M.ci > rmvC) = M.ci(M.ci > rmvC) - 1; % decrement cluster indices
    
    % See if this state has been visited
    if ~search_tabu_legal_state(M.ci,sparam)
        fprintf('tabu_state');
        M = [];
        return;
    end
    
    % Do structure learning
    M = search_clear_edges(M);
    M = search_learn_structure(M,sparam);
end