% Do structural Expectation-Maximization.
% 
% Steps:
%  (1) Compute sufficient statistics
%  (2) Do structure learning with L1-method
%  (3) Repeat until convergence
%
% Input
%  data: [nobs x m] data matrix (missing entires are inf)
%  beta: [scalar] penalty for the number of parameters
%  beta_mult_rew: [k x 1] the L0 penalty (using beta) is relaxed to a
%       continuous L1 penalty for optimization. We try this with several different amounts
%       of regularization, egual to beta*beta_mult_rew(i) for each entry
%       in the vector. Called (lambda) in paper.
%  sem_maxiter: maximum number of iterations
%  sem_stopcrit: quit when marginal score fails to improve by this much
%  sem_int_slearning: [NO longer relevant]
%  NoPen: [ntot x ntot logical] these parameters definitely exist in W
%       and should thus not be penalized.
%  W0_allowed: [ntot x ntot logical] sparisity pattern of all POTENTIALLY
%       allowable weights (any element "false" will never be turned on)
%  W0: [ntot x ntot scalar] initial weight matrix
%  sigma0: [scalar] diagonal term
%  bool_viz_prog: [logical] visualize progress of algorithm?
%  miss_info: [struct] specifies missing data pattern (see function missingpat)
%
% Output
%   W: [ntot x ntot scalar] updated weight matrix
%   W_allowed: [ntot x ntot logical] new sparsity pattern
%   sigma: [scalar] diagonal term
function [W,W_allowed,sigma] = structural_EM(data,beta,beta_mult_rew,sem_maxiter,sem_stopcrit,sem_int_slearning,...
    NoPen,W0_allowed,W0,sigma0,bool_viz_prog,miss_info)

    % Parameters and count the types of nodes
    ntot = size(W0,1);
    [nobs,m] = size(data);
    nclust = ntot-nobs;
    
    % Extend the data with the missing data portion
    data_append = inf(nclust,m);
    given = [data; data_append];    
    nunique_miss = size(miss_info.pat,2); % number of unique missing data patterns
    miss_info.pat = [miss_info.pat; false(nclust,nunique_miss)];
    
    % Initialize SEM
    score_store = [];
    smove_store = [];
    W = W0;
    W_allowed = W0_allowed; 
    sigma = sigma0;
    W_possible = W0_allowed;    
    last_W_allowed = W_allowed; % keep track of the previous sparsity pattern
    
    % Initialize parameters for EM-only updates
    lambda = zeros(size(W));
    opt_param = opt_defaultps;
    opt_stopcrit = opt_param.opt_stopcrit;
    
    % Run structural EM
    bool_slearning = true;
    for iter=1:sem_maxiter
                
        % E-step
        S = laplacian(W,sigma);
        E = inv_posdef(S);
        Y_complete = compute_suffstat(E,given,miss_info);
        
        % structure maximization step
        if bool_slearning %
            
            % Allow new parameters to become active
            [WF,WF_allowed,sigmaF] = estimate_edges_complete_data(Y_complete,m,W,W_possible,...
               sigma,NoPen,beta,beta_mult_rew);
            
        % parameter only maximization step    
        else
            [WF,sigmaF] = argmax_w(Y_complete,lambda,opt_stopcrit,W_allowed,W,sigma);
            WF_allowed = W_allowed;
        end
        
        % Plot the log-probability curve
        score = score_structural_EM(given,WF,WF_allowed,sigmaF,beta,miss_info);
        
        % If score is any improvement, change the parameters
        if iter==1 || score > score_store(end)
           W = WF;
           W_allowed = WF_allowed;
           sigma = sigmaF;
        else % if score was not improvement, make sure that the complete
           % data score agrees (general property of SEM)
           scdWF = score_complete_data(Y_complete,m,WF,WF_allowed,sigmaF,beta);
           scdW = score_complete_data(Y_complete,m,W,W_allowed,sigma,beta);
           if scdWF > scdW+1
              error('Complete data score should preserve relation with marginal score');  
           end
        end            
        
        % Record move type
        smove_store(end+1) = bool_slearning;
        
        % Stopping criterion and switching between 
        % structure and parameter modes
        bool_little_improved = iter>1 && score-score_store(end) < sem_stopcrit; 
        if bool_slearning
           if bool_little_improved || isequal(W_allowed,last_W_allowed)
              break % finish if structure didn't change since last time
           end
           last_W_allowed = W_allowed;
           bool_slearning = false;
        elseif bool_little_improved
            % improvement was small, so we start structure learning
            bool_slearning = true;
        end
 
        % Record score
        score_store(end+1) = score;
        
        % Plot progress
        if bool_viz_prog
            plot_progress(score_store,smove_store);
        end

    end
    if iter==sem_maxiter
        fprintf(1,' Max iter (%d) reached. ',iter);
    end
    
    % Record score
    score_store(end+1) = score;
        
    % Plot progress
    if bool_viz_prog
        plot_progress(score_store,smove_store);
    end
end

% Do E-step
function E_extend = compute_suffstat(E,given,miss_info)
    E_extend = fast_suffstat(E,given,miss_info);
end

% Plot the progress of EM for the iteration
function plot_progress(store_joint,smove_store)
    iter = length(store_joint);
    figure(9);
    clf
    hold on
    plot(1:iter,store_joint,'-rs','MarkerSize',5);
    for i=1:iter
        if smove_store(i)
        	plot(i,store_joint(i),'gs','MarkerSize',12);
        end
    end
    xlabel('iteration');
    ylabel('log-prob');
    title('Structural EM algorithm');
    drawnow
end