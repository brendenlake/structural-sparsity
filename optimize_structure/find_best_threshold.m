% Smart thresholding to get adjacency matrix.
% This is for fully-observed data.
%
% Take an estimate of the weight matrix for a Gaussian model. 
% Many values of the parameters should be close to zero.
% Find the optimal threshold for zero'ing out parameters.
% 
% We use a variant of fibonacci search (function min_log_search) on the set of unique threshold values.
% After each threshold, the remaining weights are reoptimized.
% This is necessary becaues cutting a dense graph will 
% cause the correlations to be underestimated without reoptimization.
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
%
% Output
%   WF: [n x n scalar] updated weight matrix
%   WF_allowed: [n x n logical] new sparsity pattern
%   sigmaF: [scalar] diagonal term
function [WF,WF_allowed,sigmaF] = find_best_threshold(Y_complete,m,W,W_allowed,sigma,NoPen,beta)
   
    % Put all the weights we can cut in a vector
    val_cut = W_allowed & ~NoPen;
    U = triu(val_cut);
    wvec = W(U);
    wvec = unique(wvec);
    wvec = wvec(:);
    wvec(wvec<.001)=[];
        
    % Possible values to threshold matrix at
    tvals = [3*eps; wvec + 3*eps];
    
    % Objective function
    opt_param = opt_defaultps;
    opt_stopcrit = opt_param.opt_stopcrit;
    fobj = @(threshold)threshold_w(threshold,Y_complete,m,W,W_allowed,sigma,NoPen,beta,opt_stopcrit);

    % Special case when wvec is empty
    if isempty(wvec)
       [score,WF,WF_allowed,sigmaF] = fobj(inf); 
       return
    end
    
    % Search for the best threshold
    tbest = min_log_search(tvals,fobj);
    [score,WF,WF_allowed,sigmaF] = fobj(tbest); 
end

% Threshold the weight matrix 
% and report the log-likelihood.
function [score,WF,WF_allowed,sigmaF] = threshold_w(threshold,Y_complete,m,W,W_allowed,sigma,NoPen,beta,opt_stopcrit)

    % Remove the weights that are below threshold
    above_threshold = sparsity_pattern(W,threshold);
    WF_allowed = W_allowed & above_threshold;    
    WF_allowed(NoPen) = true;
    W(~WF_allowed) = 0;
    
    % Re-optimize the weights
    lambda = zeros(size(Y_complete));
    [WF,sigmaF] = argmax_w(Y_complete,lambda,opt_stopcrit,WF_allowed,W,sigma);
        
    % Score the model
    lp = score_complete_data(Y_complete,m,WF,WF_allowed,sigmaF,beta);
    score = -lp;
end