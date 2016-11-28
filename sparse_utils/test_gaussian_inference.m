%% TEST GAUSSIAN INFERENCE FUNCTON
% ----
fprintf(1,'Testing Gaussian inference\n');


% TEST 1
E = eye(4);
mu = zeros(4,1);
given = [-1 1 1;inf inf inf;-1 1 -1; inf inf inf];
[mu_bar,sig_bar] = gaussian_inference_mat(mu,E,given);

fprintf(1,'\n\nTEST 1 (no covariance)\n\n');
fprintf(1,'Given mu\n');
disp(mu);
fprintf(1,'Given covariance\n');
disp(E);
fprintf(1,'Given data (columns are different queries)\n');
disp(given);
fprintf(1,'Inferred mu (columns are different queries)\n');
disp(mu_bar);
fprintf(1,'Inferred covariance\n');
disp(sig_bar);

% TEST 2
E = eye(4);
diag = logical(eye(4));
E(~diag)=.99;
mu = zeros(4,1);
given = [-1 1 1;inf inf inf;-1 1 -1; inf inf inf];
[mu_bar,sig_bar] = gaussian_inference_mat(mu,E,given);

fprintf(1,'\n\nTEST 2 (strong covariance) \n\n');
fprintf(1,'Given mu\n');
disp(mu);
fprintf(1,'Given covariance\n');
disp(E);
fprintf(1,'Given data\n');
disp(given);
fprintf(1,'Inferred mu\n');
disp(mu_bar);
fprintf(1,'Inferred covariance\n');
disp(sig_bar);

% TEST 3
E = eye(4);
diag = logical(eye(4));
E(~diag)=.2;
mu = zeros(4,1);
given = [-1 1 1;inf inf inf;-1 1 -1; inf inf inf];
[mu_bar,sig_bar] = gaussian_inference_mat(mu,E,given);

fprintf(1,'\n\nTEST 3 (weak covariance)\n\n');
fprintf(1,'Given mu\n');
disp(mu);
fprintf(1,'Given covariance\n');
disp(E);
fprintf(1,'Given data\n');
disp(given);
fprintf(1,'Inferred mu\n');
disp(mu_bar);
fprintf(1,'Inferred covariance\n');
disp(sig_bar);