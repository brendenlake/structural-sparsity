% Change properties of nodes in a graph.
% 
% Input
%   G: current graph
%   nodes_tag: cell array of node names to modfy
%   
% Output
%   G: update graph
%
function G = setGraphNodes(G,nodes_tag,varargin)
    
    % Get the optinal arguments
    showLabel = [];
    labelColor = [];
    nodeSize = [];
    nodeShape = [];
    nodeColor = [];  
    for i = 1:2:length(varargin)
        switch varargin{i}
            case 'showLabel', showLabel = varargin{i+1};
            case 'colorLabel', labelColor = varargin{i+1};
            case 'size', nodeSize =  varargin{i+1};
            case 'shape', nodeShape = varargin{i+1};
            case 'color', nodeColor = varargin{i+1};
            otherwise, error('invalid argument');
        end
    end
    
    % For each of the selected nodes
    k = length(nodes_tag);
    for i=1:k
       
        indx = find(strcmp(nodes_tag{i},G.tag));
       if isempty(indx)
          error(['Node ',nodes_tag{i},' not found']);
       end
       
       if ~isempty(showLabel)
            G.node{indx}.showLabel = showLabel; % Display label?
       end
       if ~isempty(labelColor)
            G.node{indx}.labelColor = labelColor; % Label color
       end
       if ~isempty(nodeSize)
            G.node{indx}.nodeSize = nodeSize; % Size of the node
       end
       if ~isempty(nodeShape)
            G.node{indx}.nodeShape = nodeShape; % Shape of the node
       end
       if ~isempty(nodeColor)
            G.node{indx}.nodeColor = nodeColor; % Color of the node
       end
    end
end

