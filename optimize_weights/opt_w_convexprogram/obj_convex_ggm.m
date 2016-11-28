% Objective function that we want to minimize
% when fitting a gaussian graphical model with
% a convex optimization procedure. 
%  
% Input
%  X: the parameters [k x 1]
%  Y: covariance matrix to match [n x n]
%  W_allowed: non-zero parameters [n x n]
%  lambda: L1 regularization parameters [k x 1]
%
% Output
%  obj: value of the objective
%  GX: the gradient
function [obj,GX] = obj_convex_ggm(X,Y,W_allowed,lambda)
     n = size(W_allowed,1);

    % Calculate the objective function
    [W,sigma]=vec_to_W(X,W_allowed);
    SX = laplacian(W,sigma);
    negobj = my_logdet(SX) - trace(SX*Y) - sum(sum(lambda.*W));
    obj = -negobj;
    
    % The precision matrix should always be positive definite
    if isinf(obj)
       assert(false);
    end

    % Gradient of the weights
    EX = inv_posdef(SX);
    G = zeros(n,n);
    
    % For loop over hid to hid connections
    for i=1:n
        for j=i+1:n
            G(i,j) = 2*(Y(i,j)-EX(i,j))...
                + EX(i,i)-Y(i,i)...
                + EX(j,j)-Y(j,j)...
                - 2*lambda(i,j);
        end
    end
    G = -G;
    G = G+G';
    
    % Gradient of sigma
    G_sig = 2*(sigma^(-3))*sum(diag(EX-Y));
        
    GX = W_to_vec(G,G_sig,W_allowed);
    if isnan(GX)
        assert(false);
    end 
end