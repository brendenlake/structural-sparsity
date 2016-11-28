% Default parameters for the optimization routines
function param = opt_defaultps
    param = struct;
    
    % ALL ROUTINES    
    param.opt_stopcrit=1e-4; % stopping criterion for the optimizer
    
    % EM ROUTINE
    param.em_maxiter=100; % max iterations of EM
    param.em_stopcrit=1e-1; % stopping crit EM
        % where log-score should increase by this much each iteration
        
end