% For each object, try changing
% the cluster assignment to all other possibilities
% (like in Gibbs-sampling). Objects are tried
% in a random order.
% 
% Input
%  M: structure
%
% Output
%  M: structure
%  bool_modify: [scalar logical] was the structure modified?
function [M,bool_modify] = search_cluster_swaps(M,sparam)

    nobs = M.nobs;
    order = randperm(nobs);
    score_curr = search_score(M);
    nclust = sum(search_get_clust(M));
    nchildren = search_get_nchildren(M);
    
    bool_modify = false; % was M changed?
    sclean_restarts = false; % wipe the parameters clean during restarts?
    
    if nclust==1, return; end
    
    % For each object
    fprintf(1,'Computing swap moves with %d clusters\n',nclust);
    for iter=1:nobs
        if mod(iter,10)==0, fprintf(1,'\n'); end
        
        o = order(iter);
        curr_c = M.ci(o);
        if nchildren(curr_c)==1
           % fprintf(1,'(skipped),');
           continue
        end
        fprintf(1,'%s',M.names{o});
        
        % Try all the parent options. 
        % Re-learn the parameters but not sparsity
        parent_opts = 1:nclust;
        parent_opts(curr_c) = [];
        nopt = length(parent_opts);
        S_try = cell(nopt,1);
       
        % For each of the parent options
        parfor iter_par = 1:nopt
        %for iter_par = 1:nopt
        
            % Change the parent
            popt = parent_opts(iter_par);
            S = change_parent(M,o,popt);
            
            % Only try swap if this state has not
            % been explored before
            if search_tabu_legal_state(S.ci,sparam)
                S_try{iter_par} = search_learn_parameters(S);
%               S_try{iter_par} = search_learn_single_weight(S,o);
            else
                S_try{iter_par} = [];
            end
        end
        [M_prop,score_prop] = search_pick_best(S_try);
        
        % If a proposal is accepted, relearn the sparsity too
        if score_prop > score_curr
           M = M_prop;
           M = search_try_perturb_structure(M,sparam,sclean_restarts);
           score_curr = search_score(M);
           nchildren = search_get_nchildren(M);
           bool_modify = true;
           fprintf(1,'(accepted)');            
        end
        fprintf(1,',');
    end
    fprintf(1,'\n');
end

% Change the cluster assignment of 
% the node "object" to the new assignment "latent_cluster"
function M = change_parent(M,object,latent_cluster)
    M.ci(object) = latent_cluster;
end