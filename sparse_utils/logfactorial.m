% Log of factorial function -- only works for scalars
function y = logfactorial(n)
    y = zeros(size(n));
    for i=1:numel(n)
        ind = 1:n(i);
        y(i) = sum(log(ind));
    end
end