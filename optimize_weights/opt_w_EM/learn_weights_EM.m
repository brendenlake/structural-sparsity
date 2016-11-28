% MAXIMUM LIKELIHOOD ESTIMATION
% Estimate maximum-likelihood weights with missing data... Uses the EM algorithm. 
%
% Input
%  data: [n x m] n objects by m features
%  em_maxiter: maximum number of iterations
%  em_stopcrit: stop when the log-score improves by less than this
%  opt_stopcrit: accuracy for the inner-loop convex optimizer
%  W_allowed: [n x n] logical matrix of allowed weights (non-zero)
%  W0: [n x n] matrix of initial guesses for the weight parameters
%  sigma0: [scalar] initialize guess for variance regularizer
%  nlatent_var: number of latent variables in the model (no data for them)
%     In the parameters, they are the indices at the end
%     (n+1:n+nlatent_var)
%  nobs_var: number of observed variables (n)
%  bool_viz_prog: (bool, default=false) visualize the progress of EM
%  miss_inf: structure the records missing data pattern (see function missingpat)
%  
% Output
%  W: best-fit weights
%  sigma: best-fit variance term
function [W,sigma] = learn_weights_EM(data,em_maxiter,em_stopcrit,opt_stopcrit,W_allowed,W0,sigma0,nlatent_var,nobs_var,bool_viz_prog,miss_info)

    if ~exist('bool_viz_prog','var')
       bool_viz_prog = false; 
    end
    if ~exist('miss_info','var')
        miss_info = missingpat(data);
        error('This should be cached');
    end
    
    % Various setup parameters
    dv_emcheck = 100; % flag if EM score drops by this fraction (1/x) of score
    nvar = nlatent_var + nobs_var;
    lambda = zeros(nvar); % regularization penalty, which should be 0s since this is ML
    
    % Error checking for the variable sizes
    assert(size(data,1)==nobs_var);
    assert(size(W0,1)==nvar);

    % Create appended data matrix with missing variables attached
    m = size(data,2);
    data_append = inf(nlatent_var,m);
    given = [data; data_append];
    nunique_miss = size(miss_info.pat,2); % number of unique missing data patterns
    miss_info.pat = [miss_info.pat; false(nlatent_var,nunique_miss)];
    
    % Initialize EM
    store_joint = zeros(em_maxiter,1);
    W = W0;
    sigma = sigma0;
    
    % Run EM
    for iter=1:em_maxiter
        
        % E-step
        S = laplacian(W,sigma);
        E = inv_posdef(S);
        E_extend = compute_suffstat(E,given,miss_info);
        % assert(isposdef(E_extend));
                
        % M-step
        [W,sigma] = argmax_w(E_extend,lambda,opt_stopcrit,W_allowed,W,sigma);
        
        % Plot the log-probability curve
        ljoint = score_EM(given,W,sigma,miss_info);
        store_joint(iter)=ljoint;
        if bool_viz_prog
            plot_progress(store_joint(1:iter));
        end

        % Stopping conditions
        if iter>1 && ljoint-store_joint(iter-1) < em_stopcrit
            if ljoint-store_joint(iter-1) < (-abs(store_joint(iter-1))/dv_emcheck)
                fprintf('(dec %s at i%d)', num2str(store_joint(iter-1)-ljoint,2), iter);
            end
            break
        end
    end
    if iter==em_maxiter
        fprintf(1,' Max iter (%d) reached. ',iter);
    end
end

% Do E-step
function E_extend = compute_suffstat(E,given,miss_info)
    E_extend = fast_suffstat(E,given,miss_info);
end

% This is the score, which should be non-decreasing during EM
function ls = score_EM(given,W,sigma,miss_info)
    S = laplacian(W,sigma);
    E = inv_posdef(S);
    ll = blockLL(given,E,miss_info);
    ls = ll;
end

% Plot the progress of EM for the iteration
function plot_progress(store_joint)
    iter = length(store_joint);
    figure(9);
    clf
    hold on
    plot(1:iter,store_joint,'r');
    xlabel('iteration');
    ylabel('log-prob');
    title('EM algorithm');
    drawnow
end

% % Compute sufficient statistics, by blocking the pattern of missing data.
% function E_extend = block_suffstat(E,given,miss_info)
%     [n,m] = size(given);
%     [inf_mean,inf_var]=blockGaussInf(zeros(n,1),E,given,miss_info);
%     S = zeros(n,n,m);
%     for i=1:m
%         f = given(:,i);
%         miss = isinf(f);
%         f_fill = f(:);
%         f_fill(miss) = inf_mean(miss,i);
%         S(:,:,i) = f_fill*f_fill';
%         S(miss,miss,i) = S(miss,miss,i) + inf_var(miss,miss,i);
%     end
%     E_extend = mean(S,3);
%     assert(~any(isinf(E_extend(:))));
%     assert(~any(isnan(E_extend(:))));
% end