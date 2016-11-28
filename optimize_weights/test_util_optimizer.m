% Test helper functions used during optimization
%
function test_util_optimizer

   % Check vectorization code
    fprintf(1,'TESTING VECTORIZATON CODE\n\n');
    test_wvec;
    fprintf(1,'\n\n');
    
    %% Check the block-gaussian code
    fprintf(1,'\n\nTESTING BLOCK GAUSSIAN OPERATORS (LIKELIHOOD AND INFERENCE)\n\n');
    test_block_gauss;
end

% Test code that checks
% function that converts W to a vector
function test_wvec

    n = 75;
    wrange = [.1 1]; % range of weights
    psparse = .1; % probability a graph edge is there

    sigma = rand;
    [W,W_allowed] =rlap(n,psparse,wrange);
    
    X=W_to_vec(W,sigma,W_allowed);
    [RRW,RRsigma]=vec_to_W(X,W_allowed);
    
    if aeq(W,RRW) && aeq(sigma,RRsigma)
       fprintf(1,'Vectorization code passes test.\n');
       [W(W_allowed) RRW(W_allowed)];
    end
end

% Test harness for the code that operates on solid blocks of the data matrix.
%
% Specifically, the functions for Gaussian data 
%    blockLL (block log-likelihood) and blockGaussInf (block Gaussian
%    inference)
function test_block_gauss
    n = 100; % number of objects
    psparse = .5;
    pmiss = .5; % probability an entry is missing
    nunique_miss = 8; % number of unique missing patterns
    sigma = 1;
    ndat = 1000; % number of features
    
    % Generate data from a particular sparse Laplacian
    wrange = [0 10];
    W = rlap(n,psparse,wrange);
    P = laplacian(W,sigma);
    E = inv_posdef(P);
    data = mvnrnd(zeros(n,1),E,ndat)';
    
    % Mark some entries as missing
    unique_misspat = rand(n,nunique_miss);
    r = randint(1,ndat,[1 nunique_miss]);
    U = unique_misspat(:,r);    
    data(U<pmiss) = inf;
    [n,m] = size(data);   
    
    % Compute Gaussian inference and marginal log-likelihood
    % given the efficient blocked method
    miss_info = missingpat(data);
    tic
    [mu_bar,sig_bar] = blockGaussInf(zeros(n,1),E,data,miss_info);
    llb = blockLL(data,E,miss_info);
    fprintf(1,'Block computation in %s seconds\n',num2str(toc,3));
    
    % Compute the Gaussian inference and marginal log-likelihood
    % given the much slower feature by feature method
    tic
    ll = 0;
    mu_bar_s = nan(size(mu_bar));
    sig_bar_s = nan(size(sig_bar));
    for i=1:m
        f = data(:,i);
        miss = isinf(f);
        pres = ~miss;
        npres = sum(pres);
        V = E(pres,pres);
        ll = ll + normpdfln(data(pres,i),zeros(npres,1),[],V);
        [mbar,sbar] = gaussian_inference_mat(zeros(n,1),E,f);
        mu_bar_s(miss,i) = mbar;
        sig_bar_s(miss,miss,i) = sbar;
    end
    fprintf(1,'Sequential computation in %s seconds\n',num2str(toc,3));
    
    % Extract the relevant statistics for comparison
    vmu = mu_bar(~isnan(mu_bar));
    vmu_s = mu_bar_s(~isnan(mu_bar_s));
    vsig = sig_bar(~isnan(sig_bar));
    vsig_s = sig_bar_s(~isnan(sig_bar_s));
   
    % Test to see fit
    assert(aeq(llb,ll));
    assert(aeq(vmu,vmu_s));
    assert(aeq(vsig,vsig_s));
    fprintf(1,'Block Gaussian tests passed\n');
end
