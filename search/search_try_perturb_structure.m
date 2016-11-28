% Try redoing structure learning (edge learning) for a model.
% If this improves the score, accept.
%
% Input
%  M: model
%  sparam: search parameters
%  clean_restarts: do multiple clean restarts of the parameters? (true)
%     or keep the old attachment weights? (false)
% 
% Output
%  M: updated model
%  accept: [boolean] was the perturbation an improvement?
function [M,accept] = search_try_perturb_structure(M,sparam,clean_restarts)

    if ~exist('clean_restarts','var')
        clean_restarts = true;
    end

    % Score the current model
    score_curr = search_score(M);
    
    % Score the new model
    R = search_learn_structure(M,sparam,'clean_restarts',clean_restarts);
    score_perturb = search_score(R);
    
    accept = false;
    if score_perturb > score_curr
       M = R; 
       accept = true;
    end   
end