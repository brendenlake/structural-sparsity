% function: approximately equal, for element-wise matrix comparisons
%
% Compare two matrices up to a tolerance, tol
function r = aeqm(x,y,tol)
    if nargin < 3
       tol = eps*10^10; %which is 2.2204e-06
    end
    r = abs(x-y)<tol;
end