% Make a simple neato layout
% where strong edges are small
%
% Input
%  tag: node names
%  W: [n x n scalar] weight matrix
%  W_layout: [n x n logical] use these weights for layout
%  inv_wscale: [scalar] scale the inverse weights by this much
%
% Output
%   dataXY: [n x 2 scalar] node positions in layout 
function dataXY = getNeatoLayout(tag,W,W_layout,inv_wscale)
    
    ntot = length(tag);
    
    % Get the edge lengths
    WVal_inv = zeros(ntot);
    WVal_inv(W_layout) = (1 ./ W(W_layout));
    WVal_inv = WVal_inv .* inv_wscale;
    
    % Get the positions
    bool_weighted = true;
    [pos_x,pos_y,labels] = draw_dot(WVal_inv,tag,bool_weighted);
    
    % Reorder the positions
    n = length(labels);
    dataXY = zeros(n,2);
    for labeli=1:n
       indx = strcmp(labels{labeli},tag);
       dataXY(indx,:) = [pos_x(labeli) pos_y(labeli)];
    end
    
end