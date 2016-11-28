% Transform a structure in search format
% into adjacency graph format instead.
%  (can also operate along cell arrays)
%
% Input
%   M: structure in search format (as in function search_init_model)
%     OR cell array of structures in search format
%
% Output
%   R: structure in general graph format (just weight matrix)
%     OR cell array of structures in graph format
function R = make_adj(M)
    if ~iscell(M)
        R = struct;
        [R.W,R.W_allowed,R.isclust,R.sigma] = search_makeW(M);
        R.miss_info = M.miss_info;
    else
       n = length(M);
       R = cell(n,1);
       for i=1:n
          [R{i}.W,R{i}.W_allowed,R{i}.isclust,R{i}.sigma] = search_makeW(M{i}); 
          R{i}.miss_info = M{i}.miss_info;
       end   
    end
    
end