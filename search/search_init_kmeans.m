% Try initializing the model with k-means,
% using various values of k. For each set
% of clustering candidates, we do structure learning
% between the clusters. The best scoring is picked.
%
% Input
%  M: model
%  sparam: search parameters
%
% Output
%  bestM: updated model
function bestM = search_init_kmeans(M,sparam)

    fprintf(1,'Initializing model with k-means.\n');
    
    % Pick the intervals of k to try
    nobs = M.nobs;     
    max_k = min(sparam.init_max_k,nobs);
    kint = 1:max_k;
    
    % Impute missing entries for data
    complete_data = simple_impute_data(M.data);
    
    % Search for the best K with fibonacci search
    fobj = @(k)init_try_k(k,M,sparam,complete_data);
    [best_k,best_fobj,bestM] = min_log_search(kint,fobj);
    fprintf(1,'\nPicked k=%d to start greedy algorithm.\n',best_k);
    fprintf(1,'The starting score is %s.\n',num2str(search_score(bestM),6));
end

function [score,M] = init_try_k(k,M,sparam,complete_data)

    warning('off','stats:kmeans:EmptyCluster');
    warning('off','stats:kmeans:FailedToConverge');
    idx = kmeans(complete_data,k,'replicates',25,'emptyaction','singleton');    
    M.ci = idx;
    M = search_clear_edges(M);
    M = search_learn_structure(M,sparam,'clean_restarts',true);
    M = search_try_perturb_parameters(M);    
    score = search_score(M);
    fprintf(1,'Tried k=%d with score %s\n',k,num2str(score,6));
    score = -score;
    
    if sparam.viz_graphs
        close all hidden
        displayS(search_make_graph_format(M),M.names); 
    end
end