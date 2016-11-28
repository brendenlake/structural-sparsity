if ~test_packages
   error('Required package not installed'); 
end

% ----
% Parameters
% ----

% Cell array of text file lists. Each text file contains one or more dataset
% names in the folder "data/"
files_cell = {'small.txt'};

% Cell array of beta vectors (regularization). High beta values
% means higher sparsity. For each text file, run the algorithm
% for all beta values in the corresponding vector.    
betas_cell = {[6]};

% For each text file, run the algoritm for this many replications
% for each of the beta values.
reps_cell = {1};

% Number of cores used for parallel computing
ncores = []; % empty variable means use all the available cores

% Visualize the current hypothesis during search? (true/false)
viz_progress = true;

% ----
% Conduct the search
% ----
do_search(files_cell,betas_cell,reps_cell,ncores,viz_progress);

% ----
% Visualize the results after search
% ----
close all
outdir = ['OUT_BETA',num2str(betas_cell{1},2)];

fprintf(1,'Results:\n\n');

fn = 'mini_chain';
fprintf(1,'\n\n%s\n\n',fn);
load(['data/',fn],'X','names');
displayS(X,names);
title(['Ground truth: ',fn],'Interpreter', 'none');
analyze_main_results(outdir,fn);
title(['Recovered: ',fn],'Interpreter', 'none');

fn = 'mini_ring';
fprintf(1,'\n\n%s\n\n',fn);
load(['data/',fn],'X','names');
displayS(X,names);
title(['Ground truth: ',fn],'Interpreter', 'none');
analyze_main_results(outdir,fn);
title(['Recovered: ',fn],'Interpreter', 'none');

fn = 'mini_tree';
fprintf(1,'\n\n%s\n\n',fn);
load(['data/',fn],'X','names');
displayS(X,names);
title(['Ground truth: ',fn],'Interpreter', 'none');
analyze_main_results(outdir,fn);
title(['Recovered: ',fn],'Interpreter', 'none');