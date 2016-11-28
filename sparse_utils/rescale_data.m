% Transform data such that the mean entry is 0 and the max entry in the cov. matrix is 1
%
% Data should be objects x features
function data = rescale_data(data)
    [n,m] = size(data);
    
    %Rescale like Charles's data set
    data = data - mean(data(:));
    Y_org = calc_cov(data);
    mx = max(Y_org(:));
    data = data ./ sqrt(mx);
    Y_new = calc_cov(data);
    assert(aeq(max(Y_new(:)),1));
    assert(aeq(mean(data(:)),0));
end