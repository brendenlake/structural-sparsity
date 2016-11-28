% Perform structure learning for a sparse Gaussian model.
% This assumes we have COMPLETE DATA.
% 
% It can be used stand-alone with complete data, for as
% a subroutine in a structural EM algorithm. This algorithm uses L1
% with intelligent thresholding to estimate the sparsity pattern.
%
% Input
%  Y_complete: [n x n] covariance matrix (the sufficient statistics)
%  m: number of features used to calculate the covariance matrix
%  W: [n x n scalar] weight matrix
%  W_allowed: [n x n logical] sparisity pattern of all POTENTIALLY
%       allowable weights
%  sigma: [scalar] diagonal term
%  NoPen: [n x n logical] these parameters definitely exist in W
%       and should thus not be penalized.
%  beta: [scalar] penalty for the number of parameters
%  beta_mult_rew: [k x 1] the L0 penalty (using beta) is relaxed to a
%       continuous L1 penalty for optimization. We try this with several different amounts
%       of regularization, egual to beta*beta_mult_rew(i) for each entry
%       in the vector
%
% Output
%   WF: [n x n scalar] updated weight matrix
%   WF_allowed: [n x n logical] new sparsity pattern
%   sigmaF: [scalar] diagonal term
function [WF,WF_allowed,sigmaF] = estimate_edges_complete_data(Y_complete,m,W,W_allowed,sigma,NoPen,beta,beta_mult_rew)
    
    nbeta_levels = length(beta_mult_rew);
    S = cell(nbeta_levels,1);
    scoresS = -inf(nbeta_levels,1);
    
    % Try all the levels of regularization for re-weighted L1 learning
    for i=1:nbeta_levels
        beta_rew = beta * beta_mult_rew(i);
        R = struct;
        [R.WF,R.WF_allowed,R.sigmaF] = helper_estimate_edges(Y_complete,m,W,W_allowed,sigma,NoPen,beta,beta_rew);
        S{i} = R;
        scoresS(i) = score_complete_data(Y_complete,m,R.WF,R.WF_allowed,R.sigmaF,beta);
    end
    
    % Pick the best structure found
    best_indx = argmax(scoresS);
    
    % Return the optimized structure
    WF = S{best_indx}.WF;
    WF_allowed = S{best_indx}.WF_allowed;
    sigmaF = S{best_indx}.sigmaF;
end

% Try a single level of regularization
% 
% Input
%  beta_real: [scalar] penatly for number of parameters in actual objective
%  beta_rew: [scalar] pseudo-penalty used for optimization
%
% Output
%   WT,WT_allowed,sigmaT (parameters after learning and thresholding)
function [WT,WT_allowed,sigmaT] = helper_estimate_edges(Y_complete,m,W,W_allowed,sigma,NoPen,beta_real,beta_rew)

    % Set up penalization
    lambda = (beta_rew/m) .* W_allowed;
    lambda(NoPen) = 0;
    lambda = triu(lambda,1); % only count each parameter once
    
    % Learn the parameters with L1
    opt_param = opt_defaultps;
    opt_stopcrit = opt_param.opt_stopcrit;
    [WF,sigmaF] = argmax_w(Y_complete,lambda,opt_stopcrit,W_allowed,W,sigma);
        
    % Threshold the weight matrix using intelligent search
    [WT,WT_allowed,sigmaT] = find_best_threshold(Y_complete,m,WF,W_allowed,sigmaF,NoPen,beta_real);
end