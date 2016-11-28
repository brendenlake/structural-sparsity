% Default parameters for the optimization routines
function param = sem_defaultps
    param = struct;
    
    % SEM ROUTINE
    param.sem_maxiter = 200; % max iterations of EM
    param.sem_stopcrit=1e-1; % stopping crit EM
        % where log-score should increase by this much each iteration
    param.sem_int_slearning = nan; % redo structure learning after this many iterations     
end