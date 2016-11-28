% Initialize the model structure
% (see body for input arguments)
function M = search_init_model(data,names,beta)

[n,m] = size(data); % data matrix
M = struct;

% Basic setup
M.data = data; % [n x m] data matrix (n objects x m features)
M.Y = calc_cov_missing(data); % [n x n] covariance matrix
M.miss_info = missingpat(data); % missing data information
M.names = names; % [n x 1] cell array of names for objects
M.beta = beta; % controls sparsity (larger is more sparse)
M.nobs = n; % number of observed variables

% Graph structure (n objects and k latent clusters)
M.ci = ones(n,1); % [n x 1] cluster assignment indices
M.wi = ones(n,1); % [n x 1] weight values on assignment edges
M.SK = false; % [k x k boolean] sparsity pattern between clusters
M.WK = 0; % [k x k real] weight matrix between clusters
M.sigma = 1; % diagonal term, meaning a priori standard deviation

% Book-keeping
M.last_move.type = []; % either "split" or "merge" 
M.last_move.names1 = []; % names on one side of the split/merge
M.last_move.names2 = []; % names on the other side of the split/merge

end