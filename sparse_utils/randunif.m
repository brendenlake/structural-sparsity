% Draw from uniform distribution on a continous range.
% R is a matrix of size [sz1 sz2].
% 
% Input
%   range: [1 x 2] range of random draws
%
% Output
%   R: [sz1 sz2] random numbers
function R = randunif(sz1,sz2,range)
    
    assert(numel(range)==2);
    if (range(1)>range(2))
       R = nan(sz1,sz2);
       return
    end
    
    mx_range = range(2);
    mn_range = range(1);
    U = rand(sz1,sz2);
    mlt = mx_range - mn_range;
    R = mn_range + mlt*U;
end