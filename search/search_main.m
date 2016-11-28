% Main function. Conducts search for the optimal structure.
%
% Input
%   data: [n x m scalar] n objects x m features matrix (should be rescaled)
%   names: [n x 1 cell] cell array of object names
%   beta: [scalar] amount of regularization (sparsity, larger is more
%       sparse)
%   bool_hugedata: [logical scalar] is this a huge dataset? If so
%       the search takes a few shortcuts to retain tractability
%   viz_progress: [logical] visualize progress during search by plotting
%       current graph?
%
% Output
%   M: [struct] best model found during search
%   storeM: [r x 1 cell] stores all models investigated during search
%   storeScore: [r x 1 scalar] log-probability score for each model
%   sparam: [struct] search parameters
function [M,storeM,storeScore,sparam] = search_main(data,names,beta,bool_hugedata,viz_progress)

    % Initialize the model
    sparam = search_init_search(bool_hugedata,viz_progress);
    M = search_init_model(data,names,beta);
    if sparam.init_kmeans
        M = search_init_kmeans(M,sparam);
    else
        M = search_learn_parameters(M); 
    end
    score_curr = search_score(M);
    sparam = search_tabu_add_state(M.ci,sparam); 
   
    % Store the model at each step
    storeM = {M};
    storeScore = score_curr; 
    
    % Conduct the search steps
    for iter=1:sparam.search_max_moves
        
        % Choose the type of move
        fprintf(1,'\nMove %d\n',iter);
        move_clustswap = mod(iter,sparam.search_mod_cluster_swaps) == 1;     
        
        % Generate the best move
        if move_clustswap % do cluster-swap move
            M_prop = search_cluster_swaps(M,sparam);
            score_prop = search_score(M_prop);
        
        else % do split or merge move
            data_extend = search_impute_data(M);
            S_splits = search_do_splits(M,data_extend,sparam);
            S_merges = search_do_merges(M,data_extend,sparam);
            S_moves = [S_splits; S_merges];
            M_prop = search_pick_best(S_moves);
            
            fprintf(1,'Random restarts for structure of best move.');
            [M_prop,accept_struct] = search_try_perturb_structure(M_prop,sparam);
            if accept_struct, fprintf(1,'(accepted)'); end
            fprintf(1,'\n');
            
            fprintf(1,'Random restarts for parameters of best move.');
            [M_prop,accept_param] = search_try_perturb_parameters(M_prop);
            if accept_param, fprintf(1,'(accepted)'); end
            fprintf(1,'\n');
            
            score_prop = search_score(M_prop);

            % See if the score improved
            if score_prop < score_curr
                sparam.count_decrease = sparam.count_decrease + 1;
                fprintf(1,'Score decreased, and flood counter is now %d.\n',sparam.count_decrease);
            end
            
            % Describe the best move
            fprintf(1,'Chosen ');
            search_describe_move(M_prop.last_move);
            sparam = search_tabu_add_move(M_prop.last_move,sparam);            
        end
        
        % Get the new score
        fprintf(1,'New score: %s (change %s)\n',num2str(score_prop,6),num2str(score_prop-score_curr,6));
        sparam = search_tabu_add_state(M_prop.ci,sparam);
        assert(valid_search_struct(M_prop));
        
        % Update the model        
        M = M_prop;
        score_curr = score_prop;
        
        % Store the model at each step
        storeM = [storeM; {M}];
        storeScore = [storeScore; score_curr];
        
        % Visualize the graph
        if sparam.viz_graphs
           close all hidden
           displayS(search_make_graph_format(M),names); 
        end
           
        % Check termination condition
        if sparam.count_decrease >= sparam.num_basin_flooding
            break;
        end
    end

    % Return the best structure found
    best_indx = argmax(storeScore);
    M = storeM{best_indx};
end