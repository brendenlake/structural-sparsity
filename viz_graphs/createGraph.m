% Create a graph for visualization
%
% Input
%  adj: [n x n logical] symmetric adjacency matrix
%  tag: [n x 1 cell] names of the nodes (should be unique)
%
% Output
%  G: structure supporting the graph
function G = createGraph(adj,tag)

    [n1,n2] = size(adj);
    n = length(tag);
    if (~all(islogical(adj(:))));
       error('Adjacency matrix should be logical'); 
    end
    if n~=n1 || n~=n2
       error('Label array should be same size as adjacency matrix'); 
    end
    
    G.adj = adj; % adjacency matrix [n x n]
    G.tag = tag; % tag [n x 1 cell] object names
    G.XY = zeros(n,2); % x and y coordinates of nodes
    
    G.edgeWidth = 1; % edge width
    G.fontSize = nan; % font size for labels
    
    % Node specific properties
    G.node = cell(n,1);
    for i=1:n
       G.node{i} = struct;
       G.node{i}.showLabel = true; % Display label?
       G.node{i}.labelColor = [0 0 0]; % Color of the label
       G.node{i}.nodeSize = 1; % Size of the node
       G.node{i}.nodeShape = '.'; % Shape of the node
       G.node{i}.nodeColor = [0 0 0]; % Color of the node
    end
    
    % Edge specific properties
    G.edge = cell(n);
    for i=1:n
       for j=i+1:n
          if G.adj(i,j)
                G.edge{i,j} = struct;
                G.edge{i,j}.edgeColor = [0 0 0]; % Color of the edge
                G.edge{i,j}.edgeStyle = '-'; % Style of the edge
                G.edge{i,j}.edgeBend = false; % Should the edge bend? (only works with 1D)
          end
       end
    end
    
end