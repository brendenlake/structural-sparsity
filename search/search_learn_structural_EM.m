% Do structural EM to learn the cluster to cluster
% connections in the model.
%
% Input
%   M: [struct] the model
%   sparam: [struct] search parameters
%   bool_clean_start: [boolean] reset the weights to small random values?
%
% Output
%   M: [struct] updated model
function M = search_learn_structural_EM(M,sparam,bool_clean_start)

    if ~valid_search_struct(M)
       error('Structure learning must be handed a valid search structure'); 
    end
    
    % Reset the cluster to cluster connections
    M = search_clear_edges(M); % set all cluster to cluster weights to 0
    
    % Allow all cluster to cluster connections.
    nclust = sum(search_get_clust(M));
    diagN = logical(eye(nclust));
    M.SK = ~diagN;
    
    % Set weights to small values
    if bool_clean_start
        M.wi = .1 + rand(size(M.wi));
        UWK = .1 + rand(size(M.WK));
        UWK = triu(UWK,1);
        M.WK = UWK+UWK';
    end
    
    % Update the parameters with no penalization
    M = search_learn_parameters(M);
    
    % Do structural EM
    R = search_make_graph_format(M);
    R = wrapper_structural_EM(R,M.data,M.beta,sparam);
    M = search_inv_makeW(M,R.W,R.W_allowed,R.sigma);
    
    % Do final update of parameters
    M = search_learn_parameters(M);
    
    % Try thresholding the weights
    M = search_opt_threshold(M);
end

function R = wrapper_structural_EM(R,data,beta,sparam)

    bool_viz_prog = false; % visualize score improving
    sem_param = sem_defaultps;
    
    % Indicate which edges we don't want to penalize (observed to hidden)
    NoPen = R.W_allowed;
    NoPen(R.isclust,R.isclust)=false;
        
    [R.W,R.W_allowed,R.sigma] = structural_EM(data,beta,sparam.beta_mult_rew,...
        sem_param.sem_maxiter,sem_param.sem_stopcrit,sem_param.sem_int_slearning,...
        NoPen,R.W_allowed,R.W,R.sigma,bool_viz_prog,R.miss_info);
end

