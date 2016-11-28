% Compute the observed object-wise 
% covariance matrix of a model in graph format
%
% Input
%   R: model in graph format (.W, .W_allowed)
% 
% Output
%   E: [n x n] covariance matrix
function E = getcov(R)
    P = laplacian(R.W,R.sigma);
    isobs = ~R.isclust;
    E = inv_posdef(P);
    E = E(isobs,isobs);
end