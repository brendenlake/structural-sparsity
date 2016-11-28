% Test EM algorithm for recovering weights with missing data.
function test_EM

    fprintf(1,'\n\nTESTING EM ALGORITHM FOR RECOVERING WEIGHTS\n\n');
    pmiss1 = .1;
    fprintf(1,'Prob. of missing entry is %s\n',num2str(pmiss1,3));
    test_em_helper(pmiss1);
end

% Test the EM algorithm
%
% Input: pmiss -- the probabilty of an entry missing at random
%    in the data matrix
function test_em_helper(pmiss)

    if ~exist('pmiss','var')
       pmiss = .1;
    end
    bool_viz_prog = true; % visualize the EM graph

    % Parameters
    n = 15; % number of objects
    ndat = 10000; % number of total features
    sigma = 5; % variance term
    wrange = [.1 4]; % range of weights
    psparse = .2; % probability a graph edge is there
    em_param = opt_defaultps;
    em_param.em_stopcrit = 1e-3;
    em_param.opt_stopcrit = 1e-5;
    tr_rmv = .01; % threshold
    nlatent_var = 0;
    nobs_var = n;

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
    W0 = zeros(n);
    sigma0 = 1;
    
    % Find the optimium
    [WF,sigmaF] = learn_weights_EM(data,em_param.em_maxiter,em_param.em_stopcrit,em_param.opt_stopcrit,...
        W_allowed,W0,sigma0,nlatent_var,nobs_var,bool_viz_prog,miss_info);
    WF(WF < tr_rmv)=0;
    
    % Print the recovered parameter values
    real_W = W_allowed;
    fprintf(1,'Original sigma is %d while estimate is %s\n',sigma,num2str(sigmaF,3));
    Ureal = triu(real_W);
    wvec = W(Ureal);
    wFvec = WF(Ureal);
    fprintf(1,'Original values (left) vs. recovered values (right)\n'); 
    display([wvec wFvec]);
    bigD = max(abs(W(:)-WF(:)));
    fprintf(1,'Biggest difference: %d\n',bigD);
    R = corrcoef(wvec,wFvec);
    fprintf(1,'Correlation coeff : %s\n',num2str(R(2)));
    
    % Plot comparison of ground truth versus the sparse recovery
    figure(10);
    clf;
    subplot(2,1,1);mxval=colorspy(W);xlabel('Synthetic');pbaspect('manual');set(gca,'XTickLabel',{' '});set(gca,'YTickLabel',{' '});
    subplot(2,1,2);colorspy(WF,mxval);xlabel('Estimate');pbaspect('manual');set(gca,'XTickLabel',{' '});set(gca,'YTickLabel',{' '});
end