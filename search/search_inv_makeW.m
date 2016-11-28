% Replace the weight and sigma parameters in a model
% with those given as input
%
% Input
%   M: model structure
%   W: [ntot x ntot] weight matrix
%   W_allowed: [ntot x ntot] sparsity pattern
%   sigma: [scalar] diagonal term
function M = search_inv_makeW(M,W,W_allowed,sigma) 

    % Error checking
    ntot = size(W,1);
    nobs = M.nobs;
    isclust = search_get_clust(M);
    nclust = sum(isclust);
    ntotM = length(isclust);
    ntotA = size(W_allowed,1);
    if ntot ~= ntotM || ntot ~= ntotA
       error('Weight matrix on input doesnt match model');
    end
    W_allowed_oc = W_allowed(~isclust,isclust);
    W_oc = W(~isclust,isclust);
    
    % Check to make sure attachment connectivity in W_allowed
    % matches with M
    Cinput = zeros(nobs,1);
    for o=1:nobs
       [t,Cinput(o)] = find(W_allowed_oc(o,:));
    end    
    if ~isequal(Cinput,M.ci)
       error('Cluster assignments on the input dont match model'); 
    end
   
    % Update the model variables
    M.SK = W_allowed(isclust,isclust);
    M.WK = W(isclust,isclust);
    wi = sum(W_oc,2);
    M.wi = wi(:);
    M.sigma = sigma;
end