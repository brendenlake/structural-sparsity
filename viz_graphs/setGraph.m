% Change general properties of the graph
% 
% Input
%   G: current graph
%   
% Output
%   G: update graph
function G = setGraph(G,varargin)
    
    % Get the optinal arguments
    edgeWidth = [];
    fontSize = [];
    position = [];
    for i = 1:2:length(varargin)
        switch varargin{i}
            case 'edgeWidth', edgeWidth = varargin{i+1};
            case 'fontsize', fontSize =  varargin{i+1};
            case 'positions', position = varargin{i+1};
            otherwise, error('invalid argument');
        end
    end
    
    n = length(G.tag);
    if ~isempty(edgeWidth)
        G.edgeWidth = edgeWidth;
    end
    if ~isempty(fontSize)
        G.fontSize = fontSize;
    end
    if ~isempty(position)
        [np,d] = size(position);
        if np~=n || d~=2
           error('Position matrix should be n x 2'); 
        end        
        G.XY = position;
    end
end

