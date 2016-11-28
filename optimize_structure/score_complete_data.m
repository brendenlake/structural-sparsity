% Score the model when there is complete data
% 
% Input
%   Y_complete: [ntot x ntot] full covariance matrix
%   m: [scalar] number of features used in Y_complete
%   W: [n x n scalar] weight matrix
%   W_allowed: [n x n logical] sparisity pattern of all POTENTIALLY
%       allowable weights
%   sigma: [scalar] diagonal term
%   beta: penalty on number of parameters
%
% Output
%   log_score: model score (larger is better)
function log_score = score_complete_data(Y_complete,m,W,W_allowed,sigma,beta,varargin)
    
    verbose = false;
    for i = 1:2:length(varargin)  % get optional args
        switch varargin{i}
            case 'verbose', verbose = varargin{i+1};
            otherwise, error('invalid argument');
        end
     end

    % Compute the log-likelihood
    P = laplacian(W,sigma);  
    ll = my_logdet(P) - trace(P*Y_complete);
    
    % Compute the penalization (log-prior)
    U = triu(W_allowed,1);
    nEdge = sum(sum(U));
    lpen = -(2/m) * beta * nEdge;
     
    % Compute the final score
    log_score = ll + lpen;
    
    if verbose
        fprintf(1,'Model score\n');
        fprintf(1,'      Log-like  : %s \n',num2str(ll,6));
        fprintf(1,'      Penalty   : %s (%d edges)\n',num2str(lpen,6),nEdge); 
        fprintf(1,'     Total      : %s \n',num2str(log_score,6)); 
     end
end