% Update a single weight that attaches an object to its cluster.
%
% Input
%   M: model in search format
%   obj_indx: index of the object whose attachment 
%     weight we want to optimize
%
% Output
%   M: model with updated parameters
function M = search_learn_single_weight(M,obj_indx)
    [W0,W_allowed,isclust,sigma0] = search_makeW(M);
    
    % Get the index in the weight array
    row_indx = obj_indx;
    col_indx = find(W_allowed(row_indx,:));
    assert(numel(col_indx)==1);
    
    % Do the optimization
    wxf = learn_weight_single(row_indx,col_indx,M.data,W0,sigma0,M.miss_info);
    
    % Replace the weight value
    WF = W0;
    WF(row_indx,col_indx) = wxf;
    WF(col_indx,row_indx) = wxf;
    M = search_inv_makeW(M,WF,W_allowed,sigma0);
end