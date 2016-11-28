
% Draw the graph in a figure, 
% where G is produced by "createGraph" 
%
% Output
%   handle: the handle to the figure
function handle = drawMyGraph(G)

    handle = figure;
    hold on
    n = length(G.tag);
    
    % Plot the fixed edges
    for i=1:n
        for j=i+1:n
            
            % If this is a straight edge
            if G.adj(i,j) && ~G.edge{i,j}.edgeBend               
                plot(G.XY([i j],1),G.XY([i j],2),...
                    'LineStyle',G.edge{i,j}.edgeStyle,...
                    'Color',G.edge{i,j}.edgeColor,'LineWidth',G.edgeWidth);
            
            
            % If this is a bent edge
            elseif G.adj(i,j) && G.edge{i,j}.edgeBend
               if ~all(G.XY([i j],2)==0)
                   error('Bend edges only work in 1D');
               end
               X = sort(G.XY([i j],1));
               [newX,newY] = make_parabola(X);
               scaleY = -.2 * max(G.XY(:,2));
               plot(newX,scaleY.*newY,...
                    'LineStyle',G.edge{i,j}.edgeStyle,...
                    'Color',G.edge{i,j}.edgeColor,'LineWidth',G.edgeWidth);
            end
        end
    end 
    
    % Plot the nodes
    for i=n:-1:1
       plot(G.XY(i,1),G.XY(i,2),...
           'Marker',G.node{i}.nodeShape,'MarkerSize',G.node{i}.nodeSize,...
           'MarkerFaceColor',G.node{i}.nodeColor,'MarkerEdgeColor',G.node{i}.nodeColor);
    end
    
    % Plot the tags
    for i=1:n
       if G.node{i}.showLabel
           text(G.XY(i,1),G.XY(i,2),G.tag{i},'FontSize',G.fontSize,'Color',G.node{i}.labelColor);
       end
    end
   
    %set(gca,'Visible','off');   
    set(gca,'Visible','on','XTick',[],'YTick',[]);
end

function [newX,newY] = make_parabola(X)
    sx=0:.1:pi;
    newY = sin(sx);
    distX = X(2)-X(1);
    newX = X(1) + (sx ./ sx(end)) .* distX;
end