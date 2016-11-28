% Calculate the covariance matrix, given raw data
% Data should be n objects by m features, returns the object by object
% covariance
%
% Y is n x n
function Y = calc_cov(data)
    [n,m] = size(data); %n objects by m features
    Y = (1/m).*data*data';
    % Y = cov(data');
end