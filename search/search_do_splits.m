% Propose splits of latent cluster nodes.
%
% Input
%  M: model
%  data_extend: [ntot x m] imputed full data matrix (w/ latent clusters)
%  sparam: search parameters
%
% Output
%  S_splits: [r x 1 cell] cell array of proposals for splitting
function S_splits = search_do_splits(M,data_extend,sparam)
    
    S_splits = [];
    isclust = search_get_clust(M);
    isobs = ~isclust;
    nclust = sum(isclust);
    if nclust==M.nobs, return; end
    data_obs = data_extend(isobs,:);
    
    % Choose candidates for splitting.
    seeds = [];
    % We attempt to split each latent cluster in multiple ways
    % by seeding each half with a different object.
    for c=1:nclust
       seeds = [seeds; get_seeds(M,c,sparam)]; 
    end
    % For each seed, we stochastically divide the remaining
    % objects between the two.
    cands = propose_cand_splits(M,seeds,data_obs,sparam);    
    
    % If there are too many candidates, reduce the number.
    ncands = size(cands,1);
    if ncands > sparam.split_max_cands
       rperm = randperm(sparam.split_max_cands);
       cands = cands(rperm,:);        
    end
    nsplit = size(cands,1); 
    
    % Try the splits
    fprintf(1,'Trying split moves (%d of %d)\n',nsplit,ncands);
    S_splits = cell(nsplit,1);
    
    %for i=1:nsplit
    parfor i=1:nsplit
         fprintf(1,'%d',i);
         move = struct;
         move.type = 'split';
         move.names1 = M.names(cands(i,:)==1);
         move.names2 = M.names(cands(i,:)==2);
         
         % search_describe_move(move);
         if ~search_tabu_legal_move(move,sparam)
            fprintf('tabu_move,');
            continue
         end
         S = do_split(M,cands(i,:),sparam);
         
         % Record move
         assert(valid_search_struct(M));
         if ~isempty(S), S.last_move=move; end 
         S_splits{i} = S;
         fprintf(1,',');
    end
    fprintf(1,'\n');

end

% Generate seeds for splitting a latent cluster c
%
% Output
%   seeds: [nseed x 2] indices of the seed objects, where
%     each row is a seed
function seeds = get_seeds(M,c,sparam)
    seeds = [];
    children = search_get_children(M,c);
    nchildren = numel(children);
    if nchildren==1; return; end
    ncomb = factorial(nchildren)/(2*factorial(nchildren-2));
    
    % If we can try all the seeds
    if sparam.split_nseeds >= ncomb
       seeds = enum_all_seeds(children); 
       return
    end
    
    % Pick seeds at random without replacement
    ns = min(ncomb,sparam.split_nseeds);
    seeds = zeros(ns,2);
    for s=1:ns
        while is_used(seeds(s,:),seeds(1:s-1,:))
            r = randperm(nchildren); 
            seeds(s,:) = sort(vec(children(r(1:2))),1,'ascend');
        end
    end    
end

% Is the seed x already in the list "seeds"?
% If x is the zero vector, it counts as used
%
% Input
%  x: [1 x 2] seed
%  seeds: [nseeds x 2] used seeds
%
% Output
%   used: (boolean)
function used = is_used(x,seeds)
    x=x(:)';
    used = false;
    if isequal(x,[0 0]);
       used = true;
       return;
    end    
    ns = size(seeds,1);
    for i=1:ns
       if isequal(x,seeds(i,:))
          used = true;
          return
       end
    end
end

% Manually enumerate all the possible child seeds
% for splitting a cluster
%
% Input
%   children: [k x 1] vector of child indices
%
% Output
%   seeds: [nseed x 2] indices of the seed objects, where
%     each row is a seed
function seeds =  enum_all_seeds(children)
    nchildren = length(children);
    ncomb = factorial(nchildren)./(2*factorial(nchildren-2));
    seeds = zeros(ncomb,2);
    count = 1;
    for i=1:nchildren
        for j=i+1:nchildren
            child1 = children(i);
            child2 = children(j);
            seeds(count,:) = [min(child1,child2) max(child1,child2)];
            count = count + 1;
        end
    end
end

% Turn a list of seeds into candidate proposal splits
%
% Input
%  M: model
%  seeds: [nseed x 2] indices of the seed objects, where
%     each row is a seed
%  data_obs: [n x m] imputed data matrix for observed nodes
%  sparam: search parameters
%
% Output
%  cands: [ncand x nobs] each row is a candidate split.
%     For each row, it specifies what to do with the object.
%     [1 = assign to side 1, 2 = assign to side 2, -1 = no action
function cands = propose_cand_splits(M,seeds,data_obs,sparam)
    
    ns = size(seeds,1);
    cands = -ones(ns,M.nobs);
    
    % For each seed
    for s=1:ns
       child1 = seeds(s,1);
       child2 = seeds(s,2);
       c = M.ci(child1); % the current cluster assignment
       assert(c==M.ci(child2));
        
       children = search_get_children(M,c); % the other children in cluster
       nchildren = numel(children);
       data_child1 = data_obs(child1,:);
       data_child2 = data_obs(child2,:);
       
       % For all the children in cluster c
       for i=1:nchildren
           
           % Get the current object and it's feature data
           cindx = children(i);
           data_obj = data_obs(cindx,:);
           
           % Compute the distances to the two seeds
           dist1 = norm(data_child1-data_obj);
           dist2 = norm(data_child2-data_obj);
           
           % If the current object is one of the seeds
           if aeq(dist1,0), cands(s,cindx) = 1; continue; end
           if aeq(dist2,0), cands(s,cindx) = 2; continue; end
           
           % Determine the probability of assignment
           if dist1 <= dist2
              p_side1 = sparam.split_prob_closer; 
           else
              p_side1 = (1-sparam.split_prob_closer);
           end
           
           % Make the assignment
           if rand < p_side1
               cands(s,cindx) = 1;
           else
               cands(s,cindx) = 2; 
           end
           
       end
    end
    
    % Remove duplicate candidates
    cands = delete_duplicate(cands,1);
    assert(all(cands(:) == 1 | cands(:) == 2 | cands(:) == -1));
end

% Split a latent cluster into two nodes.
% After the split, redo structure learning.
function M = do_split(M,cand,sparam)
    nclust = max(M.ci);
    in_newclust = cand==2;
    M.ci(in_newclust) = nclust + 1; % decrement cluster indices
    
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