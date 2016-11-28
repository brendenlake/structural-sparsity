% Find the optimal threshold of a weight matrix.
% The edges for small values are turned "off."
%
% We search over threshold values using an efficient fibonacci search.
%
% Pick the value of thresholding
% that optimizes the model score.
function M = search_opt_threshold(M)

    % Get the unique weight values
    U_cc = logical(triu(M.SK,1));
    wvec = vec(M.WK(U_cc));
    wvec = unique(wvec);
    wvec = wvec(:);
    wvec(wvec<.001)=[];

    % Possible values to threshold matrix at
    tvals = [3*eps; wvec + 3*eps];
    fobj = @(threshold)threshold_w(threshold,M);
    
    % Special case when wvec is empty
    if isempty(wvec)
       [score,M] = fobj(inf);
       return
    end

    % Search for the best threshold
    [tbest,tbest_fobj,M] = min_log_search(tvals,fobj);    
end

% Threshold the weight matrix 
% and report the score
function [score,M] = threshold_w(threshold,M)
   
    % Remove the weights that are below threshold
    oldSK = M.SK;
    M.SK = sparsity_pattern(M.WK,threshold);
    M.SK = M.SK & oldSK;
    M.WK(~M.SK)=0;
    
    % Re-optimize the weights
    M = search_learn_parameters(M);
        
    % Score the model
    lp = search_score(M);
    score = -lp;
    
    % fprintf(1,'Threshold=%s score=%s\n',num2str(threshold,3),num2str(score,6));
end