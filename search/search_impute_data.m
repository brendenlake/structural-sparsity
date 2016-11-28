% We want to estimate the full data matrix,
% including the feature for the latent variables.
% 
% Output
%  data_extend: [ntot objects x m features] 
%     best guess of the data matrix.
function data_extend = search_impute_data(M)
    
    [n,m] = size(M.data);
    isclust = search_get_clust(M);
    obs = ~isclust;
    nclust = sum(isclust);
    ntot = nclust + M.nobs;
    
    % Extended data matrix
    data_extend = inf(ntot,m);
    data_extend(obs,:) = M.data;
    misspat = isinf(data_extend);
    miss_info = M.miss_info;
    nuniq = size(miss_info.pat,2);
    miss_info.pat = [miss_info.pat; false(nclust,nuniq)];
    
    % Perform inference
    [W,W_allowed,isclust,sigma] = search_makeW(M);
    P_full = laplacian(W,sigma);
    E_full = inv_posdef(P_full);
    mu = zeros(size(E_full,1),1);
    mu_bar = blockGaussInf(mu,E_full,data_extend,miss_info);
    
    % Fill in the missing values
    data_extend(misspat) = mu_bar(misspat);    
end