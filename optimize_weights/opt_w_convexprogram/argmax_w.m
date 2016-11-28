% MAXIMUM LIKELIHOOD ESTIMATION
% Find the optimal weights for a given covariance matrix.
%
% This calls a routine that solves the problem.
%
% Input
%  Y: empirical covariance (n x n)
%  lambda: penalization for each element of W (n x n)
%  stopcrit: smaller the value the more accurate the optimization
%  W_allowed: logical matrix of which weights can be non-zero
%  W0: Initial weights
%  sigma0: Initial regularization term
%
% Output
%  WF: optimal weights
%  sigmaF: optimal regularization term
%  optval: optimal value of the objective function
function [WF,sigmaF,optval] = argmax_w(Y,lambda,stopcrit,W_allowed,W0,sigma0)
    [WF,sigmaF,optval] = argmax_w_primal(Y,lambda,stopcrit,W_allowed,W0,sigma0);
end