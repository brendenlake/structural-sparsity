% Renumber cluster assignments so that
% the first unique cluster is 1, the second is 2, etc.
%
% Input
%  ci: [n x 1] cluster assignment
%
% Output
%  ci_arrange: [n x 1] renumbered assignment
function ci_arrange = search_tabu_arrange_state(ci)
    ci = ci(:);
    ci_unique = delete_duplicate(ci,1); 
    ci_arrange = zeros(size(ci));
    for i=1:length(ci_unique)
        val = ci_unique(i);
        sel = ci==val;
        ci_arrange(sel) = i;        
    end
end