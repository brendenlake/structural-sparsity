% Get the children of a latent cluster c
%
% Input
%   M: model
%   c: latent cluster index
%
% Output
%   children: [p x 1] indices of children
function children = search_get_children(M,c)
    children = find(M.ci==c);
end