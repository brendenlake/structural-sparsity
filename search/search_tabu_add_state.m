% Add a cluster assignment to the list of visited states.
% The algorithm will not revisit these states.
%
% Input
%  ci: [n x 1] cluster assignment
%  sparam: search parameters
%
% Output
%  sparam: search parameters updated
function sparam = search_tabu_add_state(ci,sparam)
    ci_arrange = search_tabu_arrange_state(ci);
    sparam.tabu_states{end+1} = ci_arrange;
end