% Brenden Lake
%
%   Same as log(nchoosek(n,k))
%   using the MATLAB builtin but
%   stable for large numbers.
%
function y = lognchoosek(n,k)
    y = logfactorial(n)-logfactorial(k)-logfactorial(n-k);
end

