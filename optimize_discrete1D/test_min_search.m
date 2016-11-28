%
% Test the search procedures in this folder.
% They operate on a 1D convex function.
%
function test_min_search
    
    X = 1:30;
    min = X(randint(1,1,[1 length(X)]));
    fobj = @(x)convex_func(x,min);
    
    fprintf(1,'Array size: %d\n',length(X));
    [Y,fY,outargY] = min_log_search(X,fobj);
    
%     % Also test linear and fibonacci search
%     [Y2,fY,outargY] = min_lin_search(X,fobj);
%     [Y3,fY,outargY] = min_fib_search(X,fobj);
%     assert(Y==Y2&&Y==Y3);
%     fprintf(1,'Linear search matches output\n');
%     fprintf(1,'Fibonacci search matches output\n');
    
    fprintf(1,'Function minimum is: %s\n',num2str(min,3));
    fprintf(1,'Search found       : %s\n',num2str(Y,3));
end

function [y,x] = convex_func(x,min)
    y = (x-min).^2 + (x-min).^4;
    fprintf(1,'x=%s, f(x)=%s\n',num2str(x,3),num2str(y,3));
end