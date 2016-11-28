% Objective function of structural EM.
% This is the marginal likelihood rather than the 
% completed data likelihood.
%
% Input
%  data: [ntot x m] full data matrix (missing entires are inf)
%  W: [ntot x ntot scalar] weight matrix
%  W_allowed: [ntot x ntot logical] sparisity pattern
%  sigma: [scalar] diagonal term
%  beta: [scalar] penalty for the number of parameters
%  miss_info: [struct] specifies missing data pattern (see function missingpat)
%
% Output
%   log_score: model score (larger is better)
function log_score = score_structural_EM(data,W,W_allowed,sigma,beta,miss_info,varargin)
    
     verbose = false;
    for i = 1:2:length(varargin)  % get optional args
        switch varargin{i}
            case 'verbose', verbose = varargin{i+1};
            otherwise, error('invalid argument');
        end
     end

    % Compute the log-likelihood
    P = laplacian(W,sigma);
    E = inv_posdef(P);
    ll = blockLL(data,E,miss_info);
    
    % Compute the penalization (log-prior)
    U = triu(W_allowed,1);
    nEdge = sum(sum(U));
    lpen = -beta*nEdge;
     
    % Compute the final score
    log_score = ll + lpen;
    
    if verbose
        fprintf(1,'Model score\n');
        fprintf(1,'      Log-like  : %s \n',num2str(ll,6));
        fprintf(1,'      Penalty   : %s (%d edges)\n',num2str(lpen,6),nEdge); 
        fprintf(1,'     Total      : %s \n',num2str(log_score,6)); 
     end
end