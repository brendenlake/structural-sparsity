% Softmax function of vector x
% 
% Input
%   x: [k x 1] vector
% 
% Output
%   P: [k x 1] probability vector
function p = softmax(x)    
    prop = exp(-x);
    p = prop ./ sum(prop);
end