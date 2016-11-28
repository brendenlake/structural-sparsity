% Find the minimum of a function (fobj).
% This simply checks all of the elements in X.
%
% Input
%   X: set of elements
%   fobj: objective function [val,outarg] = fobj(X(i))
%
% Output
%   Y: element of X that minimizes the function
%   fY: function value at Y
%   outargY: auxillary output variable associated with Y (not the score)
function [Y,fY,outargY] = min_lin_search(X,fobj)
    n = length(X);
    fbest = inf;    
    for i=1:n
        xi = X(i);
        [fi,oi] = fobj(xi);        
        if fi < fbest
           ibest = i;
           fbest = fi;
           outargY = oi;            
        end        
    end
    Y = X(ibest);
    fY = fbest;
end
