% You have a multivariate Gaussian defined by mu and covariance E. We want
% to perform inference for the missing entires in given, which are denoted
% as "inf". The other entries are the values to be conditioned on.
%
% Input:
%     mu: [n x 1] mean vector
%     E: [n x n] covariance matrix
%     given: [n x m] data matrix, where each column is a separate inference
%           problem. Each column must have the same pattern of missing entries.
%           Missing data is denoted by "inf".
%
% Output:
%     mu_bar: [nmiss x m] the inferred missing values of the given matrix,
%       for each of the corresponding columns of given
%     sig_bar: [nmiss x nmiss] this is the same for each inference
function [mu_bar,sig_bar] = gaussian_inference_mat(mu,E,given)
    n = size(E,1);
    [n2 m] = size(given);
    assert(n==n2);
    assert(~any(isnan(given(:))));
    
    % Make sure there is the same pattern of missing data for each column
    miss = isinf(given(:,1));
    for i=1:m
       assert(isequal(miss,isinf(given(:,i)))); 
    end
    assert(aeq(E,E'));
    
    % Rearrange for missing data pattern
    in = ~miss;
    k=sum(miss);
    e11=E(miss,miss);
    e12=E(miss,in);
    e21 = e12';
    e22 = E(in,in);
    mixE = [e11 e12; e21 e22];
    X2 = given(in,:);
    [mu_bar,sig_bar] = conditional_gaussian(mu,mixE,k,X2);
end


% A Gaussian [X1; X2] ~ Normal
% partioned as [mu1; mu2] and [sig11 s12; s21 sig22]
% We want the distribution of X1 given X2
% Where k is the last element (index) in X1
%
% Each column of X2 is a difference inference we want to make.
function [mu_bar,sig_bar] = conditional_gaussian(mu,sigma,k,X2)
    n = length(mu);
    mu1 = mu(1:k);
    mu2 = mu(k+1:n);
    sig11 = sigma(1:k,1:k);
    sig12 = sigma(1:k,k+1:n);
    sig21 = sigma(k+1:n,1:k);
    sig22 = sigma(k+1:n,k+1:n);
    term = sig12/sig22;
    sig_bar = sig11 - term*sig21;
    m = size(X2,2);   
    mu_bar = zeros(k,m);
    for i=1:m
       mu_bar(:,i) =  mu1 + term*(X2(:,i)-mu2);
    end
end