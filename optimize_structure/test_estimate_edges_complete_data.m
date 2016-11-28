%
% Test structure learning with complete data
%   function: estimate_edges_complete_data
%
function test_estimate_edges_complete_data

    fprintf(1,'\n\nTESTING STRUCTURE LEARNING FROM COMPLETE DATA\n\n');
    
    % Search parameters
    beta = 6; % sparsity
    beta_mult_rew = [.5 1 2]; % scaling factors on sparsity to try

    % Data parameters
    n = 15; % number of objects
    m = 1000; % number of total features
    sigma = 5; % variance term
    wrange = [1 4]; % range of weights
    psparse = .2; % probability a graph edge is there

    % Construct the original weights and ata
    [W,W_allowed] = rlap(n,psparse,wrange);
    P = laplacian(W,sigma);
    E = inv_posdef(P);
    data = mvnrnd(zeros(n,1),E,m)';
    
    % Set up the inputs to the optimizer
    W0 = zeros(n);
    W0_allowed = ~logical(eye(n));
    sigma0 = 1;
    NoPen = false(n);
    
    % Find the optimium
    Y_complete = calc_cov(data);
    [WF,WF_allowed,sigmaF] = estimate_edges_complete_data(Y_complete,m,W0,W0_allowed,sigma0,NoPen,beta,beta_mult_rew);   
    
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
    
    % Plot comparison of ground truth versus the sparse recovery
    figure(10);
    clf;
    subplot(2,1,1);mxval=colorspy(W);xlabel('Synthetic');pbaspect('manual');set(gca,'XTickLabel',{' '});set(gca,'YTickLabel',{' '});
    subplot(2,1,2);colorspy(WF,mxval);xlabel('Estimate');pbaspect('manual');set(gca,'XTickLabel',{' '});set(gca,'YTickLabel',{' '});
end