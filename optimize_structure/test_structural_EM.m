%
% Test Structural EM algorithm for recovering
%   sparse connectivity with missing data.
% 
%    function: structural_EM
%
function test_structural_EM

    fprintf(1,'\n\nTESTING STRUCTURAL EM ALGORITHM\n\n');
    pmiss1 = .1;
    fprintf(1,'Prob. of missing entry is %s\n',num2str(pmiss1,3));
    test_SEM_helper(pmiss1);
    
end

% Test the EM algorithm
%
% Input: pmiss -- the probabilty of an entry missing at random
%    in the data matrix
function test_SEM_helper(pmiss)

    if ~exist('pmiss','var')
       pmiss = .1;
    end
    bool_viz_prog = true; % visual progress of SEM

    % Search parameters
    beta = 6; % amount of sparsity
    beta_mult_rew = [.5 1 2]; % L1 approximation parameters
    
    % Data parameters
    n = 15; % number of objects
    m = 1000; % number of total features
    sigma = 5; % variance term
    wrange = [1 4]; % range of weights
    psparse = .2; % probability that a graph edge is there

    % Construct the original weights
    [W,W_allowed] = rlap(n,psparse,wrange);
    P = laplacian(W,sigma);
    E = inv_posdef(P);
    data = mvnrnd(zeros(n,1),E,m)';
    
    % Data missing at random
    U = rand(size(data));
    data(U<pmiss) = inf;
    miss_info = missingpat(data);
    
    % Set up the inputs to the optimizer
    W0 = zeros(n);
    W0_allowed = ~logical(eye(n));
    sigma0 = 1;
    NoPen = false(n);
    
    % Find the optimium    
    sem_param = sem_defaultps;
    [WF,WF_allowed,sigmaF] = structural_EM(data,beta,beta_mult_rew,sem_param.sem_maxiter,...
        sem_param.sem_stopcrit,sem_param.sem_int_slearning,...
        NoPen,W0_allowed,W0,sigma0,bool_viz_prog,miss_info);
    
    % Look at the recovered sparsity pattern
    U = triu(true(n),1);
    nextra = sum(WF_allowed(U) > W_allowed(U)+eps);
    nmiss = sum(WF_allowed(U) < W_allowed(U)-eps);
    fprintf(1,'Number of false positive edges: %d\n',nextra);
    fprintf(1,'Number of missing edges       : %d\n',nmiss);
    
    % Compare recovered vs. optimal sigma
    fprintf(1,'Original sigma is %d while estimate is %s\n',sigma,num2str(sigmaF,3));
    
    % Compare the weight values
    real_W = W_allowed;    
    Ureal = triu(real_W);
    wvec = W(Ureal);
    wFvec = WF(Ureal);
    fprintf(1,'Original values (left) vs. recovered values (right)\n'); 
    display([wvec wFvec]);
    bigD = max(abs(W(:)-WF(:)));
    fprintf(1,'Biggest difference: %d\n',bigD);
    rr = corrcoef(wvec,wFvec);
    fprintf(1,'Correlation coeff : %s\n',num2str(rr(2)));
    
    % Comparison of score
    fprintf(1,'\nCompare the scores\n');
    log_score_real = score_structural_EM(data,W,W_allowed,sigma,beta,miss_info);
    fprintf(1,'Real score     : %s\n',num2str(log_score_real,5));
    log_score_recover = score_structural_EM(data,WF,WF_allowed,sigmaF,beta,miss_info);
    fprintf(1,'Recovered score: %s\n',num2str(log_score_recover,5));

    
    % Plot comparison of ground truth versus the sparse recovery
    figure(10);
    clf;
    subplot(2,1,1);mxval=colorspy(W);xlabel('Synthetic');pbaspect('manual');set(gca,'XTickLabel',{' '});set(gca,'YTickLabel',{' '});
    subplot(2,1,2);colorspy(WF,mxval);xlabel('Estimate');pbaspect('manual');set(gca,'XTickLabel',{' '});set(gca,'YTickLabel',{' '});
end