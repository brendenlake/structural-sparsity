% Plot a simple adjacency matix,
% with no distinction between
% cluster nodes and objects
function [f,G] = displayW(W)
    n = size(W,1);
    names = [];
    M.W = W;
    M.W_allowed = W>eps;
    M.isclust = true(n,1);
    [f,G] = displayS(M,names,'style','synth');
end