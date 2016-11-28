% Test code related to convex optimizer
% for learning a Gausisan with L1 penalization
%
function test_convexprogram

    % Check optimizer while recovering weight values
    fprintf(1,'TESTING WEIGHT RECOVERY\n\n');
    test_argmax_w(true);
    fprintf(1,'\n\n');
    
    % Check optimizer while recovering sparsity
    fprintf(1,'TESTING SPARSITY (L1) WEIGHT RECOVERY\n\n');
    test_argmax_w(false);
    fprintf(1,'\n\n');    
end

% Test of convex optimization procedure to recover
% the weights of a graph, given features. 
%
% Input
%   bool_vals_only:  (true/default=false) if true,
%     assume the sparsity is given and recover the parameters
%
function test_argmax_w(bool_vals_only)

    if ~exist('bool_vals_only','var');
        bool_vals_only = false;
    end

    % Parameters
    n = 15; % number of objects
    ndat = 10000; % number of total features
    beta = .01*ndat; % regularization
    sigma = 5; % variance term
    wrange = [.1 1]; % range of weights
    psparse = .1; % probability a graph edge is there
    stopcrit = 1e-20; % accuracy of optimizer
    tr_rmv = .01; % threshold

    % Construct the original weights
    [W,real_W] = rlap(n,psparse,wrange);
    P = laplacian(W,sigma);
    E = inv_posdef(P);
    data = mvnrnd(zeros(n,1),E,ndat)';
    
    % Set up the inputs to the optimizer
    Y = calc_cov(data);
    dg = logical(eye(n));
    lambda = (beta/ndat) .* ~dg;
    if bool_vals_only
         W_allowed = real_W;  % Assume sparsity given by an Oracle
    else
         W_allowed = ~dg; % allow all parameters a priori
    end     
    W0 = zeros(n);
    sigma0 = 1;
    
    % Find the optimium
    [WF,sigmaF] = argmax_w(Y,lambda,stopcrit,W_allowed,W0,sigma0);
    WF(WF < tr_rmv)=0;
    
    % Check the gradient
    fprintf(1,'Checking gradient\n');
    X0 = W_to_vec(W0,sigma0,W_allowed); 
    checkgrad('obj_convex_ggm',X0,1e-6,Y,W_allowed,lambda);
    
    % Print the recovered parameter values
    fprintf(1,'\nOriginal sigma is %d while estimate is %s\n',sigma,num2str(sigmaF,3));
    Ureal = triu(real_W);
    wvec = W(Ureal);
    wFvec = WF(Ureal);
    fprintf(1,'Original values (left) vs. recovered values (right)\n'); 
    display([wvec wFvec]);
    bigD = max(abs(W(:)-WF(:)));
    fprintf(1,'Biggest difference: %d\n',bigD);
    
    % Plot comparison of ground truth versus the sparse recovery
    figure(10);
    clf;
    subplot(2,1,1);mxval=colorspy(W);xlabel('Synthetic');pbaspect('manual');set(gca,'XTickLabel',{' '});set(gca,'YTickLabel',{' '});
    subplot(2,1,2);colorspy(WF,mxval);xlabel('Estimate');pbaspect('manual');set(gca,'XTickLabel',{' '});set(gca,'YTickLabel',{' '}); 
end