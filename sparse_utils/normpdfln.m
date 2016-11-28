% Calls lightspeed toolbox.
% This is for backwards compatibility with 
% the old lightspeed naming scheme.
function p = normpdfln(x, m, S, V)
p = mvnormpdfln(x, m, S, V);