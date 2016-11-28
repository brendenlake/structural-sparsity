%
% Score a sparse graph with the primary objective function.
%
% Input
%  R: model in graph format (.W, .W_allowed)
%  data: [n x m scalar] data matrix already rescaled
%  beta: sparsity penalty
%  
% varargin
%   'verbose'={true,false} print breakdown of score
%   'miss_info'= cached output of function missingpat
%
% Output
%   log_score: the log-probability (score)
%
function log_score = grandscore(R,data,beta,varargin)

     assert(~isscalar(data));
     assert(isscalar(beta));
   
     % Analyze extra arguments
     verbose = false;
     miss_info = [];
     for i = 1:2:length(varargin)  % get optional args
        switch varargin{i}
            case 'verbose', verbose = varargin{i+1};
            case 'miss_info', miss_info = varargin{i+1};
            otherwise, error('invalid argument');
        end
     end
     
     % Get the pattern of missing data
     if isempty(miss_info)
         fprintf(1,'Missing data pattern not cached, which could be slow.\n');
         miss_info = missingpat(data);
     end
     
     % Compute the log-likelihood
     E = getcov(R);
     ll = blockLL(data,E,miss_info);
     
     % Compute the penalization (log-prior)
     U = triu(R.W_allowed,1);
     nEdge = sum(sum(U));
     lpen = -beta*nEdge;
     
     % Compute the final score
     log_score = ll + lpen;
     
     % Verbose mode gives details
     if verbose
        fprintf(1,'Model score\n');
        fprintf(1,'      Log-like  : %s \n',num2str(ll,6));
        fprintf(1,'      Penalty   : %s (%d edges)\n',num2str(lpen,6),nEdge); 
        fprintf(1,'     Total      : %s \n',num2str(log_score,6)); 
     end
end