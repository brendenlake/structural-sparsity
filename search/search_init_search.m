% Set parameters that govern the search process
% 
% Input
%   bool_hugedata: [logical] is this a huge dataset?
%   viz_progress: [logical] visualize progress during search?
%
% Output
%   sparam: [struct] stores all parameters
%
function sparam = search_init_search(bool_hugedata,viz_progress)

    sparam = struct;
    if ~exist('viz_progress','var')
       viz_progress = true; 
    end

    % ----
    % PARAMETERS
    % ----        
    
    % Model initialization
    sparam.bool_hugedata = bool_hugedata; % [boolean] is this a huge dataset?
    sparam.init_kmeans = true; % initialize the model with k-means?
    sparam.init_max_k = 100; % maximum value of k to try when initializing
    
    % Search procedure parameters
    sparam.search_max_moves = 100; % maximum number of search moves
    sparam.search_mod_cluster_swaps = 3; % intervals at which 
        % we propose cluster swaps rather than splits and merges
    
    % termination count on the number of greedy steps the algorithm
    % will take without improving score
    sparam.num_basin_flooding = 5;
    
    % Tabu search
    % --
    % Tabu list stores moves that reverse recent actions
    sparam.tabu_moves_length = 0; % length of the tabu list
    sparam.tabu_moves = []; % cell array that holds tabu list
    % Tabu states stores all previous visited states
    sparam.tabu_states = []; % cell array that holds cluster
      % assignment
        
    % Merge moves
    
    % maximum number of merges to try at each step
    if sparam.bool_hugedata
        sparam.merge_max_cands = 8;
    else
        sparam.merge_max_cands = 30;
    end
    
    sparam.merge_cand_temperature = [0 4]; % allow heuristic distances between
        % clusters to range from [x1 x2] (x1 to x2). Merges are tried
        % with probability proportional to exp(-dist).
        
    % Split moves
    sparam.split_nseeds = 3; % For each latent cluster, the model
        % attempts to split it in two, by assigning two current "seed"
        % children of the latent cluster to either side of the split. 
        % How many of these seed children should be tried?
    sparam.split_prob_closer = .9; % The other children of the splitting
        % cluster have to be assigned to one "seed" child or the other.
        % What is the probability of picking the closer seed child (as determined 
        % by distance in feature space)?
    sparam.split_max_cands = sparam.merge_max_cands;
        % maximum number of candidate splits to try
        
    % Structure learning by sparse parameter estimation
    
    % Multipliers of beta term
    % for use during re-weighted L1 (pen is beta.*beta_mult_rew(i))
    if sparam.bool_hugedata
        sparam.beta_mult_rew = 1;
    else        
        sparam.beta_mult_rew = [.5 1 2]; 
    end
    sparam.nrestart_slearn = 5; % when doing structure learning from
        % completely random weights, how many random restarts?
    
    % Visualization
    sparam.viz_graphs = viz_progress; % visualize graphs during search?
        
    % ----
    % DO NOT CHANGE
    % ----
        
    % Search book-keeping
    sparam.count_decrease = 0; % number of steps the algorithm
        % has taken that did not improve score
end