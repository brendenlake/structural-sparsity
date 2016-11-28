%
% Default parameters for function displayS
%
function param = default_displayParam

    % Parameters
    param = struct;
    
    % Truncate weights at this minimum
    % and maximum value
    param.minw = -inf;
    param.maxw = 20;
    
    % After changing the edges from weight
    % space to length space (1/weights), scale
    % the values this much to make it easier
    % for Neato
    param.inv_wscale = 100;
  
    % Size of the names on the graph
    param.name_size = 15;
    
    % If we are ignoring the weight values,
    % the weights between clusters are valued at 1.
    % This is the value of the attachment weights
    param.ignore_wt_attachscale = 1.2;
end