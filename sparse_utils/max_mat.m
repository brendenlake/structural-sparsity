% Find the maximum value in a matrix A.
% This operates on the entire matrix.
%
% Input
%   A: [n x m] matrix
%
% Output
%  val_max: maximum value in matrix
%  maxi: row index of max
%  maxj: column index of max

function [val_max,maxi,maxj] = max_mat(A)
    assert(size(A,3)==1);
    [B,maxj] = max(A,[],2);
    [val_max,maxi] = max(B);
    maxj = maxj(maxi);
end