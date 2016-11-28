% What is the pattern of missing data?
%
% Input
%  data: [n x m] data matrix
%    'inf' in the matrix marks a missing entry
% 
% Output
%  miss_info: structure that caches the information
%    about missing data
%  
%  fields:
%  ---
%    pat: [n x k logical] unique observed patterns where "true" is observed (columns of data)
%    indx: [m x 1] which data column belongs to which pattern (valued 1 to k)
%  
function miss_info = missingpat(data)
    given = ~isinf(data);
    [pat,t,indx] = unique(given','rows');
    pat = pat';
    pat = logical(pat);
    
    % Caching structure for missing data pattern
    miss_info.pat = pat;
    miss_info.indx = indx;
end