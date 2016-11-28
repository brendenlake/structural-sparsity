function [x, y, labels] = draw_dot(adj, labels, bool_weighted)
%
% [x, y, labels] = draw_dot(adj, lables)   draw a graph defined by adjacency matrix 
%  
% Sample code illustrating use of graph_to_dot and dot_to_graph.m functions
%     for interfacing  GraphViz layout and Matlab UI powers  
%
% (C) Dr. Leon Peshkin  pesha @ ai.mit.edu  /~pesha     24 Feb 2004
%
[n,m] = size(adj);
   if n ~= m, warning('not a square adjacency matrix!'); end
   if isequal(triu(adj,1),tril(adj,-1)'), directed = 0; else, directed = 1; end
weights = [];
if bool_weighted
   weights = adj; 
end
adj = double(abs(adj) > 0);    % make sure it is a binary matrix cast to double type
      % to be platform independant no use of directories in temporary filenames
tmpDOTfile = '_GtDout.dot';           tmpLAYOUT  = '_LAYout.dot'; 
graph_to_dot(adj, 'directed',directed,'weighted',weights,'filename', tmpDOTfile); % save in file
if ispc, shell = 'dos'; else, shell = 'unix'; end                %  Which OS ?
 
% cmnd = strcat(shell,'(''neato -V'')');    % request version to check NEATO is there
% status = eval(cmnd);
% if status == 1,  warning('DOT/NEATO not accessible'); end
 
         %  put all your favorite  NEATO attributes  here 
neato = '(''neato -Tdot -Gmaxiter=25000 -Gregular '; % -Gstart="regular" -Gregular  
neato = strcat([neato '-Gminlen=1 -Goverlap=false']);  %true']);   % minimal edge length, no overlap   
if n > 100   % some extra NEATO options for over populated graphs 
    neato = strcat([neato '-x']);      
end
cmnd = strcat([shell neato ' -o' tmpLAYOUT ' ' tmpDOTfile,'''',')']);    % -x compact
status = eval(cmnd);                 %  get NEATO to layout

[trash, names, x, y] = dot_to_graph(tmpLAYOUT);  % load NEATO layout
num_names = str2num(char(names))';
nam_len = length(names);
if nam_len < n  % plot singletons without coordinates all together in a lower left 
    num_names(nam_len+1:n) = my_setdiff(1:n, num_names);
    x(nam_len+1:n) = 0.05*ones(1,n-nam_len);
    y(nam_len+1:n) = 0.05*ones(1,n-nam_len);
end
[ignore,lbl_ndx] = sort(num_names);  % recover from dot_to_graph node_ID permutation 
x = x(lbl_ndx); y = y(lbl_ndx);  
if nargin == 1 || isempty(labels)                                   % if no labels were provided 
    labels = names(lbl_ndx);
end
delete(tmpLAYOUT); delete(tmpDOTfile);     % clean up temporary files 