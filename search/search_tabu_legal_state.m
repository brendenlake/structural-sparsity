% Check whether a cluster assignment (ci) is
% legal. It is illegal if it has already been
% visited during search.
%
% Input
%  ci: [n x 1] cluster assignment
%  sparam: search parameters
%
% Output
%  bool_legal: [scalar logical] is the move legal?
function bool_legal = search_tabu_legal_state(ci,sparam)
    ci_arrange = search_tabu_arrange_state(ci);
    bool_legal = true;
    
    % Check to see if the cluster assignment was used before
    ns = length(sparam.tabu_states);
    for s=ns:-1:1
        if isequal(ci_arrange,sparam.tabu_states{s})
            bool_legal = false;
            return
        end
    end
end