% Convert a weight matrix W and regularization sigma into the parameter vector X
function X=W_to_vec(W,sigma,W_allowed)
    WU_all = triu(W_allowed,1);
    X = W(WU_all);
    X = [sigma; X];
end