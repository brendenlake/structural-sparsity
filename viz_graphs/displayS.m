% Generic graph visualization function,
% used to display the graphs in the paper.
% 
% Example uses:
%   displayS(M,names);
%   displayS(M,names,'style','colors','eigen_plot',2);
%   displayS(M,names,'style','animals');
%
% Can used neato algorithm from graphviz (default)
%   or eigenvectors to lay out the nodes in the graph.
%
% Input
%  M: graph structure is adjacency format
%    should contain fields...
%       .W: [n x n scalar] weight matrix for all nodes in the graph
%       .W_allowed [n x n logical] binary matrix for active connections
%          (non-zero elements of W)
%       .isclust = [n x 1 logical] which nodes are latent clusters?
%       .sigma = [scalar] variance parameter
%
%  names: [nobs x 1] names for the first nobs nodes in M, 
%       which are the observed nodes
%  
% Other arguments, called by 
%  
%  displayS(M,names,'arg1',val1,'arg2',val2,....) in any order
%
%  layout_edges: [n x n logical] only use these edges in the layout
%      others are assumed to be 0
%  file_pdf: print the graph to a pdf with this filename
%
%  eigen_plot: [default=nan], use eigenvectors of implied covariance
%    (Lawrence) to lay out the graphs. Values should be (1 or 2)
%
%  ignore_weights: [default=false] if true, make all edges the same
%    length
%
%  style: display graph in a certain style from the paper,
%      where options are:
%          'senate' : show whole senate graph
%          'colors' : display nodes in the right color
%          'synth' : used for synthetic data (don't show object names)
%          'peace' : only for peace sign synthetic dataset
%          'animals' : highlight maximum strength spanning tree
%          'judges' : used with first eigenvector, this shows 
%               outlying connections
%          'mammals_subset' : just show a small subset of the mammals
%          'map' : overlay on the best 2D solution of the spatial model
%          'huge' : used for the 200 object dataset with small name font
%          'mammals' : same as animals but with color difference
%          'senate_backbone' : sketch senate outline with a few key people
%          'senate_dems': just plot the senate democrats
%          'senate_gop' : just plot the senate republicans  
%          'plain' : (default)
%
function [f,G] = displayS(M,names,varargin)
    
    [s,o] = system('which neato');
    if s~=0
       f = figure;
       fprintf(1,'Neato (from graphviz) is not installed.\n');
       fprintf(1,'Graph failed to visualize.\n');
       return
    end

    M.W_allowed = logical(M.W_allowed);

    % Default parameters
    layout_edges = [];
    fn_pdf = [];
    eigen_plot = nan;
    style = 'plain';
    ignore_weights = false;
    
    % Get the optinal arguments
    for i = 1:2:length(varargin)
        switch varargin{i}
            case 'layout_edges', layout_edges = varargin{i+1};
            case 'file_pdf', fn_pdf = varargin{i+1};
            case 'style', style = varargin{i+1};
            case 'eigen_plot', eigen_plot = varargin{i+1};
            case 'ignore_weights', ignore_weights = varargin{i+1};
            otherwise, error('invalid argument');
        end
    end
    
    % Parameters
    param = default_displayParam;
    
    % Count the nodes in the graph
    ntot = size(M.W,1);
    obs = ~M.isclust;
    nobs = sum(obs);
    hid = ~obs;
    nhid = sum(hid);
    
    % Create the node IDs
    tag = cell(ntot,1);
    tag(1:nobs) = names;
    for i=nobs+1:ntot
        tag{i}=['h',num2str(i)];
    end
    
    % Create the biograph object 
    G = createGraph(M.W_allowed,tag);
       
    if isempty(layout_edges)
        W_layout = M.W_allowed;
    else
        W_layout = layout_edges;
    end
    if isnan(eigen_plot)
        
        % Set the node positions with Neato
        if strcmp(style,'animals');
            W_layout = getSpanTree(M,tag);
        end
        
        % Should the layout account for the weight values?
        if ignore_weights
            WNeato = double(M.W_allowed);
            WNeato(obs,hid) = WNeato(obs,hid) .* param.ignore_wt_attachscale;
            WNeato(hid,obs) = WNeato(hid,obs) .* param.ignore_wt_attachscale;
        else
            WNeato = M.W;
            toosmall = M.W_allowed & M.W < param.minw;
            WNeato(toosmall) = param.minw;
            toobig = M.W_allowed & M.W > param.maxw;
            WNeato(toobig) = param.maxw;
        end
        
        % Do the layout
        dataXY = getNeatoLayout(tag,WNeato,W_layout,param.inv_wscale);
    else
        
        % Set the node positions in the Eigenspace 
        dataXY = getEigenLayout(M,eigen_plot);
    end
    
    % Set the positions
    G = setGraph(G,'positions',dataXY);
    
    % Modify the node style
    G = setGraphNodes(G,tag(obs),'size',1,'color',[1 1 1]);
    G = setGraphNodes(G,tag(hid),'showLabel',false);
    G = setGraph(G,'fontsize',param.name_size);
    switch style
        case 'senate', G = setStyleSenate(G);
        case 'colors', G = setStyleColors(G);
        case 'synth',  G = setStyleSynthetic(G,obs);
        case 'peace',  G = setStylePeace(G,M);
        case 'animals', G = setStyleAnimals(G,W_layout,M);
        case 'judges', G = setStyleJudges(G,M);
        case 'mammals_subset', G = setStyleSubMammals(G,M);
        case 'map', G = setStyleMap(G,M);
        case 'huge', G = setStyleHuge(G);
        case 'mammals', G = setStyleMammals(G,W_layout);
        case 'senate_backbone', G = setStyleSenateBackbone(G);
        case 'senate_dems', G = setStyleSenateDems(G);
        case 'senate_gop', G = setStyleSenateGOP(G);    
        case 'plain', G = setGraphNodes(G,G.tag(~obs),'size',20,'color',[.5 .5 .5]);
        otherwise, error('invalid style name');
    end
    
    % Draw the graph
    f = drawMyGraph(G);
    pause(.01);
    drawnow 
    
    % Print the figures to pdf
    if ~isempty(fn_pdf)
        pdf_gcf(fn_pdf);
    end
end