% Draw a random laplacian matrix.
% 
% Input
%   n: W is (n x n)
%   psparse: the proportion of entries that are sparse
%   wrange: the range of weights is [wrange(1) wrange(2)]
%
% Output
%   W: random matrix
%   W_allowed: non-zero parameters (logical, n x n)
function [W,W_allowed]=rlap(n,psparse,wrange)
    u = rand(n);
    wr = wrange(1)+(wrange(2)-wrange(1))*rand(n,n);
    on = u<psparse;
    on = triu(on,1);
    U = zeros(n);
    U(on) = wr(on);
    W = U+U';
    W_allowed = logical(on+on');
end