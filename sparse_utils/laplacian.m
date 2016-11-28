% Compute the graph Laplacian 
function L=laplacian(W,sigma)

    % Error checking
    U = triu(W,1);
    if ~isequal(W,U+U')
       error('W must be symmetric'); 
    end

    % Compute the graph laplacian
    n = size(W,1);
    L = diag(sum(W,2)) - W + eye(n)./(sigma^2);
end