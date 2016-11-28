% Find maximum likelihood parameters in the model (theta = [W,sigma]).
% Optimization uses the EM-algorithm.
%
% Input
%  data: [n x m] n observed objects by m features
%     missing entries are denoted by "inf"
%  W0: [ntot x ntot real] initial weights
%  sigma0: [scalar] initial sigma
%  W_allowed: [ntot x ntot logical] sparsity pattern
%  isclust: [ntot x 1 logical] is this a latent cluster node?
%  miss_info: pattern of missing data (see function missingpat)
%
% Output
%  WF: [ntot x ntot real] final weights
%  sigmaF: [scalar] final sigma value
function [WF,sigmaF] = optimize_weights(data,W0,sigma0,W_allowed,isclust,miss_info)
    
    % Error checking
    [n,m] = size(data);
    assert(sum(isclust==false)==n);
    assert(size(W0,1)==length(isclust) && size(W0,1) == size(W_allowed,1));        
    
    % Do the optimization  
    [WF,sigmaF] = opt_using_em(data,W0,sigma0,W_allowed,isclust,miss_info);
end

% Find maximum likelihood weights using EM
function [WF,sigmaF] = opt_using_em(data,W0,sigma0,W_allowed,isclust,miss_info)
    nhid = sum(isclust);
    ntot = size(W0,1);
    bool_viz_prog = false; % do not visualize EM as it goes
    param = opt_defaultps;
    nobs = ntot-nhid;
    [WF,sigmaF] = learn_weights_EM(data,param.em_maxiter,param.em_stopcrit,...
        param.opt_stopcrit,W_allowed,W0,sigma0,nhid,nobs,bool_viz_prog,miss_info);
end