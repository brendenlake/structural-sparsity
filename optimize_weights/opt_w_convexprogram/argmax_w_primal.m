% Find the optimal weights for a given covariance matrix.
% This function solves the primal optimization problem.
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
function [WF,sigmaF,optval] = argmax_w_primal(Y,lambda,stopcrit,W_allowed,W0,sigma0)
    X0 = W_to_vec(W0,sigma0,W_allowed);
    
    % Error checking to ensure vectorizing works
    [W1,sigma1]=vec_to_W(X0,W_allowed);
    assert(aeq(sigma1,sigma0) && aeq(W1,W0)); % ensures 
    assert(all(X0>=-eps));
    
    % Set up objective and constraints
    fObj = @(X)obj_convex_ggm(X,Y,W_allowed,lambda);
    fProj = @(X)projX_inc0(X);

    % Solve the optimization problem
    X=opt_pqn(fObj,fProj,X0,stopcrit);
%   X=opt_fmincon(fObj,X0,stopcrit);
    
    % Save the answer
    optval = fObj(X);
    [WF,sigmaF] = vec_to_W(X,W_allowed);
end
 

% Optimize using Projected Quasi-Newton Algorithm by Schmidt et al. 2009
function X=opt_pqn(fObj,fProj,X0,stopcrit)
    options.verbose=0;
    options.optTol=stopcrit;
    X = minConF_PQN(fObj,X0,fProj,options);
end

% Optimize using Interior-point method in the Matlab toolbox
function X=opt_fmincon(fObj,X0,stopcrit)
    nvar = length(X0);
    A = -eye(nvar);
    b = zeros(nvar,1);
    op = optimset('GradObj','on','Display','iter','Algorithm','interior-point','Hessian','lbfgs','TolFun',stopcrit,'DerivativeCheck','on');
    X = fmincon(fObj,X0,A,b,[],[],[],[],[],op);
end