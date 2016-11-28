% Make an eigenspace layout, as described in Lawrence
%
% Input
%  M: model in adjacency format
%  eigen_plot: [scalar] 1: one-dimension, 2: two-dimensions
%
% Output
%   dataXY: [n x 2 scalar] node positions in layout 
function dataXY = getEigenLayout(M,eigen_plot)

    assert(eigen_plot==1 || eigen_plot==2);

    obs = ~M.isclust;
    nobs = sum(obs);
    hid = ~obs;
    nhid = sum(hid);       
    
    % Get and center the covariance matrix
    E = inv_posdef(laplacian(M.W,M.sigma));
    E = center_cov(E);
    
    % Get the eigenvectors
    [V,D] = eig(E);
    eigenvals = vec(diag(D));
    [sort_eigenvals,sort_indx] = sort(eigenvals,1,'descend');
    clustXY = [V(:,sort_indx(1)) V(:,sort_indx(2))];
    clustXY = clustXY(hid,:); % only hidden variables
    
    % Normalize the data
    clustXY = clustXY - mean(clustXY(:));
    clustXY = clustXY ./ std(clustXY(:));    
    if eigen_plot == 1, clustXY(:,2) = 0; end
    
    % Get cluster ID for objects
    clustID = zeros(nobs,1);
    for o=1:nobs
        clustID(o) = find(M.W_allowed(o,:))-nobs;
    end
    
    % Create positions for objects by extending vector
    % from the center to the cluster
    obsXY = zeros(nobs,2);
    center = mean(clustXY,1);
    vnorm = .2;
    
    % For each cluster node
    for c=1:nhid
        
        % Get objects assigned to cluster
        in_clust = find(clustID==c);
        nin = numel(in_clust);
        
        % Determine unit vector from cluster to baseline
        clustPos = clustXY(c,:);
        if eigen_plot == 2
            v = clustPos - center;
            v = v ./ norm(v);
        else
            v = [0 1]; 
        end
            
        % Rotate and scale unit vector to place all the children
        tdeg = 360;
        rot = tdeg/nin;
        if eigen_plot == 1, rot = 180; end
        offset = 0;
        if nin > 3, offset = 45; end
        for i=1:nin
            o = in_clust(i);            
            obsXY(o,:) = clustPos + rotate(v .* vnorm, rot*(i-1) + offset);
        end
        
    end
    
    dataXY = [obsXY; clustXY];
    
    % Change the polarity of the positions if necessary    
    if dataXY(1,1) > 0, dataXY(:,1) = -1*dataXY(:,1); end    
    if eigen_plot == 2 && dataXY(1,2) > 0, dataXY(:,2) = -1*dataXY(:,2); end

end

% Center the covariance matrix E
function B = center_cov(E)
    n = size(E,1);
    H = eye(n) - ones(n)./n;
    B = H*E*H;
end

% Rotate a vector [v1 v2] 
% around an angle theta (in degrees)
function v = rotate(v,theta)
    M = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
    v = M * v(:);
    v = v(:)';
end