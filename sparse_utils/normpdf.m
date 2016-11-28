% Calls lightspeed toolbox.
% This is for backwards compatibility with 
% the old lightspeed naming scheme.
function p = normpdf(varargin)
p = mvnormpdf(varargin);