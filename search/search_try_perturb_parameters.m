% Reset the weights of a current model M to
% small random values. Reoptimize the parameters.
% If the score improves, accept the new values.
%
% Input
%  M: model
% 
% Output
%  M: updated model
%  accept: [boolean] was the perturbation an improvement?
function [M,accept] = search_try_perturb_parameters(M)

    % Score the current model
    score_curr = search_score(M);
    [W0,W_allowed,isclust,sigma0] = search_makeW(M);
    
    % Reset weight matrix to be small random values
    U = logical(triu(W_allowed,1));
    WR = .1 + rand(size(W0));
    WR(~U) = 0;
    WR = WR+WR';
    sigmaR = max(1,sigma0+randn);
    
    % Optimize the new parameters
    R = search_inv_makeW(M,WR,W_allowed,sigmaR);
    R = search_learn_parameters(R);
    score_perturb = search_score(R);
    
    accept = false;
    if score_perturb > score_curr
       M = R; 
       accept = true;
    end    
end