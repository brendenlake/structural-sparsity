% Change the style of certain graph edges
%
% Input
%  G: input graph
%  toMark: [n x n logical] change these edges
%  color: new line color (RGB value)
%  style: new line style (--,-,-.,etc.)
%  bend: [logical] should the edge bend? (only 1D layout)
%
% Output
%  G: output graph
function G = markEdges(G,toMark,color,style,bend)

    assert(aeq(toMark,toMark'));
    if ~all(G.adj(toMark))
       error('Marking non-existent edge'); 
    end

    n = length(G.tag);
    for i=1:n
        for j=i+1:n
            if toMark(i,j)
                G.edge{i,j}.edgeColor = color;
                G.edge{i,j}.edgeStyle = style;
                G.edge{i,j}.edgeBend = bend;
            end
        end
    end

end