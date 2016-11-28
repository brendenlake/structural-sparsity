% Transform the data with missing entries like Kemp and Tenenbaum (2008).
% The data is scaled to have a mean value of 0. The largest
% set of features that are present for the same objects are captured,
% and the data is scaled so the largest element of that sub-covariance
% matrix is 1.
%
% Input
%   data: [n x m] for n objects by m features.
%     missing value are indicated by inf
%
% Output
%   data: [n x m] rescaled data 
function data = rescale_data_missing(data)
    
    % Set mean to zero 
    data = data - mean(data(~isinf(data)));
%     assert(any(isinf(data(:))));
    
    % Find the missing pattern and the largest chunk of features
    miss_info = missingpat(data);
    pat = miss_info.pat;
    indx  = miss_info.indx; 
    uindx = unique(indx);
    nindx = length(uindx);
    count_indx = zeros(nindx,1);
    for i=1:length(uindx)
        count_indx(i) = sum(indx==uindx(i));        
    end
    max_indx = uindx(argmax(count_indx));
    sel_indx = indx==max_indx;
    data_sel = data(pat(:,max_indx),sel_indx);
    assert(any(~isinf(data_sel(:))));
    
    % Rescale data
    Y_org = calc_cov(data_sel);
    mx = max(Y_org(:));
    data = data ./ sqrt(mx);
    
    % Error checking
    data_sel2 = data(pat(:,max_indx),sel_indx);
    Y_new = calc_cov(data_sel2);
    assert(aeq(max(Y_new(:)),1));
    assert(aeq(mean(data(~isinf(data))),0));
end