% Given a set of candidate structures,
% select the best scoring move.
%
% Input
%   S: cell array of structures M
%
% Output
%   Mbest: best element in array S
%   score_best: score of best element
function [Mbest,score_best] = search_pick_best(S)
    ns = length(S);
    scores = -inf(ns,1);
    for i=1:ns
        if ~isempty(S{i})
            scores(i) = search_score(S{i});
        end
    end
    indx_best = argmax(scores);
    Mbest = S{indx_best};
    score_best = scores(indx_best);
end