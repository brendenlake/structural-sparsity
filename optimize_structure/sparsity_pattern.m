% Select all weights (W) that are larger than threshold (thresh)
%
% Input
%   W: [n x n] weight parameters
% 
% Output
%   W_allowed: [n x n logical] sparsity pattern
function W_allowed = sparsity_pattern(W,thresh)
    if nargin < 2
       thresh=.01; 
    end
    W_allowed = W >= thresh;
    diagN = logical(eye(size(W_allowed,1)));
    W_allowed(diagN) = false;
end