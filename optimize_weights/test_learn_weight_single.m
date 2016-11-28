% Test function that holds out one weights,
% and attempts to optimize it while leaving all others constant.
% This was not used in the final structural sparsity algorithm.
%
function test_learn_weight_single

    fprintf(1,'\n\nTESTING LEARNING OF A SINGLE WEIGHT\n\n');
    pmiss1 = .1;
    fprintf(1,'Prob. of missing entry is %s\n',num2str(pmiss1,3));
    test_single_helper(pmiss1);    
end

% Test the EM algorithm
%
% Input: pmiss -- the probabilty of an entry missing at random
%    in the data matrix
function test_single_helper(pmiss)

    if ~exist('pmiss','var')
       pmiss = .1;
    end

    % Parameters
    n = 15; % number of objects
    ndat = 1000; % number of total features
    sigma = 5; % variance term
    wrange = [.1 4]; % range of weights
    psparse = .2; % probability a graph edge is there

    % Construct the original weights
    [W,W_allowed] = rlap(n,psparse,wrange);
    P = laplacian(W,sigma);
    E = inv_posdef(P);
    data = mvnrnd(zeros(n,1),E,ndat)';
    
    % Data missing at random
    U = rand(size(data));
    data(U<pmiss) = inf;
    miss_info = missingpat(data);
    
    % Set up the inputs to the optimizer
    W0 = W;
    sigma0 = sigma;
    [on_row_indx,on_col_indx] = find(W_allowed);
    r = randint(1,1,[1 length(on_row_indx)]);
    row_indx = on_row_indx(r);
    col_indx = on_col_indx(r);
    
    % Find the optimium
    wxf = learn_weight_single(row_indx,col_indx,data,W0,sigma0,miss_info);
    wx_real = W(row_indx,col_indx);
    
    % Print the recovered parameter values
    fprintf(1,'Parameter index [%d %d]\n',row_indx,col_indx);
    fprintf(1,'Real weight value: %s\n',num2str(wx_real,4));
    fprintf(1,'Recovered weight value: %s\n',num2str(wxf,4));
end