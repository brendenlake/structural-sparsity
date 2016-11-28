% Maximize likelihood while changing one weight value,
% keeping all the others fixed.
%
% Input
%  row_indx: row of weight to be optimized
%  col_indx: column of weight to be optimized
%  data: [n x m] n objects by m features (inf has missing values)
%  W0: [n x n] matrix of initial guesses for the weight parameters
%  sigma0: [scalar] initialize guess for variance regularizer
%  miss_inf: structure the records missing data pattern (see function missingpat)
% 
% Output
%  wxf: optimized value of the weight
function wxf = learn_weight_single(row_indx,col_indx,data,W0,sigma0,miss_info)
    
    % Bounds on the weight we are optimizing
    wx_lower_bound = 0.01;
    wx_upper_bound = 50;
    tol = .1; % tolerance on the weight value
    
    % Objective function
    fobj = @(wx)single_obj(wx,row_indx,col_indx,W0,sigma0,data,miss_info);
    
    % Do optimization
    options = optimset('TolX',tol);
    wxf = fminbnd(fobj,wx_lower_bound,wx_upper_bound,options);
end

% Negative of the log-likelihood function 
function score_min = single_obj(wx,row_indx,col_indx,W_fix,sigma_fix,data,miss_info)
    W = W_fix;
    W(row_indx,col_indx) = wx;
    W(col_indx,row_indx) = wx;
    P = laplacian(W,sigma_fix);
    E = inv_posdef(P);
    nobs = size(data,1);
    E = E(1:nobs,1:nobs);   
    ll = blockLL(data,E,miss_info);
    score_min = -ll;
end