if ~test_packages
   error('Required package not installed'); 
end

% ----
% Parameters
% ----

% Cell array of text file lists. Each text file contains one or more dataset
% names in the folder "data/"
files_cell = {'larger.txt','small.txt'};

% Cell array of beta vectors (regularization). High beta values
% means higher sparsity. For each text file, run the algorithm
% for all beta values in the corresponding vector.    
betas_cell = {[6],[6]};

% For each text file, run the algoritm for this many replications
% for each of the beta values.
reps_cell = {1,1};
% repts_cell = {10,1}  %% 10 replications were run for the paper

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

fn = 'colors';
fprintf(1,'\n\n%s\n\n',fn);
analyze_main_results(outdir,fn,'style','colors','eigen_plot',2);
title(['Graph for: ',fn],'Interpreter', 'none');

fn = 'judges';
fprintf(1,'\n\n%s\n\n',fn);
analyze_main_results(outdir,fn,'style','judges','eigen_plot',1);
title(['Graph for: ',fn],'Interpreter', 'none');

fn = 'faces';
fprintf(1,'\n\n%s\n\n',fn);
analyze_main_results(outdir,fn,'eigen_plot',2);
title(['Graph for: ',fn],'Interpreter', 'none');

fn = 'animals';
fprintf(1,'\n\n%s\n\n',fn);
analyze_main_results(outdir,fn,'style','animals');
title(['Graph for: ',fn],'Interpreter', 'none');