% Perform  search for the minimum of a 1D function.
% Consider all the discrete elements in X (sorted in smallest to largest).
%
% This procedure is designed to avoid local minima in 
% a fibonacci search over a non-convex function.
%
% (Step 1) Try a range of X(i) values (equally spaced intervals in
%   log-space)
% (Step 2) Find the best (Xbest) of these X(i) values
% (Step 3) Do a more careful fibonacci search in the range
%   bounded by the tried interval around Xbest (assumes a convex function)
% (Step 4) Return the best solution visited
%
%
% Input
%   X: sorted set of elements
%   fobj: objective function [val,outarg] = fobj(X(i))
%   nsteps_log: number of log steps to try
%
% Output
%   Y: element of X that minimizes the function
%   fY: function value at Y
%   outargY: auxillary output variable associated with Y (not the score)
function [Y,fY,outargY] = min_log_search(X,fobj,nsteps_log)
    
    % Error checking
    assert(aeq(X,sort(X)));
    n = length(X);
    if ~exist('nsteps_log','var');
        nsteps_log = min(ceil(n/3),10); 
    end
    if n<=5
       [Y,fY,outargY] = min_lin_search(X,fobj);
       return
    end

    % Get a subset of X, known as Xsteps,
    % which are spaced over X on a log scale
        
    loglb = log(1);
    logub = log(n);
    int_step = (logub-loglb)/(nsteps_log-1);
    logsteps = loglb:int_step:logub;
    steps = exp(logsteps);
    steps = round(steps);
    steps = unique(steps);
    nsteps = length(steps);
    Xsteps = X(steps);
    
    % Try the value of all these log steps
    % and pick the best
    [best_Xstep,bestF_Xstep,best_outarg_step] = min_lin_search(Xsteps,fobj);
    
    % Get the log step above and below
    indx_best = find(best_Xstep == Xsteps);
    prev_indx = max(indx_best-1,1);
    next_indx = min(indx_best+1,nsteps);
    
    % Make array (Xfib) of all values in 
    % X in between the log step above and below
    lb_best_Xstep = find(Xsteps(prev_indx)==X)+1;
    ub_best_Xstep = find(Xsteps(next_indx)==X)-1;
    
    % Do a more detailed search in this interval
    % use fibonacci search
    if ub_best_Xstep >= lb_best_Xstep
        Xfib = X(lb_best_Xstep:ub_best_Xstep);
        [best_Xfib,bestF_Xfib,best_outarg_fib] = min_fib_search(Xfib,fobj);
    else
        bestF_Xfib = inf;
    end
    
    % Return the best value seen
    if bestF_Xfib < bestF_Xstep
        Y = best_Xfib;
        fY = bestF_Xfib;
        outargY = best_outarg_fib;
    else
        Y = best_Xstep;
        fY = bestF_Xstep;
        outargY = best_outarg_step;
    end
end
