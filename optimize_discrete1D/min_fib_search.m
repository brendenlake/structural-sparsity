% Perform fibonacci search for the minimum of a function. The
% function should be convex on the set X, where X is 
% a sorted array (smallest to largest).
%
% Input
%   X: sorted set of elements
%   fobj: objective function [val,outarg] = fobj(X(i))
%   max_evals: maximum number of evaluations (default=450)
%
% Output
%   Y: element of X that minimizes the function
%   fY: function value at Y
%   outargY: auxillary output variable associated with Y (not the score)
function [Y,fY,outargY] = min_fib_search(X,fobj,max_evals)

    if ~exist('max_evals','var')
       max_evals = 450; 
    end

    assert(aeq(X,sort(X)));
    n = length(X);
    
    % Special cases
    if n==1
       Y = X;
       [fY,outargY] = fobj(X);
       return;
    end    
    if n==2
       [f1,o1] = fobj(X(1));
       [f2,o2] = fobj(X(2));
       if f1 < f2
          Y = X(1); 
          fY = f1;
          outargY = o1;
       else
          Y = X(2);
          fY = f2;
          outargY = o2;
       end
       return
    end
    
    % Set the initial search points
    x1 = 1;
    x3 = n;
    x2 = probe(x1,x3);
    [f1,o1] = fobj(X(x1));
    [f3,o3] = fobj(X(x3));
    [f2,o2] = fobj(X(x2));
    nevals = 3;
    
    % Store the output arguments
    outargStore = cell(n,1);
    outargStore{x1} = o1;
    outargStore{x2} = o2;
    outargStore{x3} = o3;    
    
    % Find the best value so far
    xret = [x1; x2; x3];
    fret = [f1; f2; f3];
    bindx = argmin(fret);
    xbest = xret(bindx);
    fbest = fret(bindx);
    
    % Return the best value we saw
    [xbest,fbest,outargStore] = search_step(x1,x2,x3,f1,f2,f3,X,fobj,xbest,fbest,nevals,max_evals,outargStore);
    Y = X(xbest);
    fY = fbest;
    outargY = outargStore{xbest};
end

function [xbest,fbest,outargStore] = search_step(x1,x2,x3,f1,f2,f3,X,fobj,xbest,fbest,nevals,max_evals,outargStore)

    % fprintf(1,'x1=%s,x2=%s,x3=%s\n',num2str(x1,3),num2str(x2,3),num2str(x3,3));
    % fprintf(1,'f1=%s,f2=%s,f3=%s\n\n',num2str(f1,2),num2str(f2,2),num2str(f3,2));

    % Base case where array is of size 3
    if x1+1==x2 && x2+1==x3
       return
    end
    
    % If limit has been reached, return the best point so far
    if nevals >= max_evals
       fprintf(1,['fibonacci search reached maximum function evals (',num2str(max_evals),')']);
       return;
    end
    
    % There is still mass on the right hand side
    left_size = x2-x1;
    right_size = x3-x2;
    nevals = nevals + 1;
    if right_size > left_size
        x4 = probe(x2,x3);
        [f4,o4] = fobj(X(x4));
        outargStore{x4} = o4;
        [xbest,fbest] = update_xbest(x4,f4,xbest,fbest);
        if f4 > f2
            [xbest,fbest,outargStore] = search_step(x1,x2,x4,f1,f2,f4,X,fobj,xbest,fbest,nevals,max_evals,outargStore);
        else
            [xbest,fbest,outargStore] = search_step(x2,x4,x3,f2,f4,f3,X,fobj,xbest,fbest,nevals,max_evals,outargStore);
        end
    else
        x4 = probe(x1,x2);
        [f4,o4] = fobj(X(x4));
        outargStore{x4} = o4;
        [xbest,fbest] = update_xbest(x4,f4,xbest,fbest);
        if f4 > f2
            [xbest,fbest,outargStore] = search_step(x4,x2,x3,f4,f2,f3,X,fobj,xbest,fbest,nevals,max_evals,outargStore);
        else
            [xbest,fbest,outargStore] = search_step(x1,x4,x2,f1,f4,f2,X,fobj,xbest,fbest,nevals,max_evals,outargStore);
        end
    end
end

% See if a candidate x is better than 
% the best so far.
function [xbest,fbest] = update_xbest(xcand,fcand,xbest,fbest)
    if fcand < fbest
        xbest = xcand;
        fbest = fcand;
    end
end

% Get the probe value x_probe,
% depending on the values x_left and x_right
function x_probe = probe(x_left,x_right)
    n = (x_right-x_left)+1;
    F = generate_fib(n);
    x_probe = x_left + F(1);
end

% Get the first fibonacci number greater than or equal two n.
% Return the two numbers that compose that number.
function F = generate_fib(n)
    F = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233,...
        377, 610, 987, 1597, 2584, 4181, 6765, 10946, 17711, 28657, 46368, 75025, 121393];
    indx = find(F>=n,1,'first');
    F = F([indx-2 indx-1]);    
end