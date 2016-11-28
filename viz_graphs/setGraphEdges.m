% Change properties of edges in the graph.
% This changes edges in bulk, consisting of
% all edges from set1 to set2
% 
% Input
%   G: current graph
%   nodes_tag1: cell array of node names, set 1
%   nodes_tag2: cell array of node names, set 2
%   
% Output
%   G: update graph
function G = setGraphEdges(G,nodes_tag1,nodes_tag2,varargin)
    
    % Get the optinal arguments
    edgeColor = [];
    edgeStyle = [];
    for i = 1:2:length(varargin)
        switch varargin{i}
            case 'color', edgeColor = varargin{i+1};
            case 'style', edgeStyle = varargin{i+1};
            otherwise, error('invalid argument');
        end
    end
    
    % For each of the nodes
    n1 = length(nodes_tag1);
    n2 = length(nodes_tag2);
    for i=1:n1
        for j=1:n2
           indx1 = find(strcmp(nodes_tag1{i},G.tag));
           indx2 = find(strcmp(nodes_tag2{j},G.tag));
           
           if G.adj(indx1,indx2)
               
               indx = sort([indx1; indx2],1,'ascend');
               
               if ~isempty(edgeColor)
                    G.edge{indx(1),indx(2)}.edgeColor = edgeColor;
               end
               
               if ~isempty(edgeStyle)
                    G.edge{indx(1),indx(2)}.edgeStyle = edgeStyle;
               end
               
           end
           
        end
    end
    
end

