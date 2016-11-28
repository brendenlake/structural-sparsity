% Convert a parameter vector (X) into it's matrix form (W) with 
% the regularization parameter sigma. W_allowed lists which
% weights are active in the matrix
function [W,sigma]=vec_to_W(X,W_allowed)
    sigma=X(1);
    X = X(2:end);
    WU_all = triu(W_allowed,1);
    nfill = sum(sum(WU_all));
    assert(numel(X)==nfill);
    W = zeros(size(W_allowed));
    W(WU_all) = X;
    W = W+W';
end