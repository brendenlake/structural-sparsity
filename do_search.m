%
% Conduct search on a list (or several lists) of datasets.
%
% For use caes, see "run_small_set" and "run_larger_set".
%
% Input
%  files_cell: [n x 1 cell] Cell array of text file lists. Each text file contains one or more dataset
%       names in the folder "data/"
%  betas_cell: [n x 1 cell] Cell array of beta vectors (regularization). High beta values
%       means higher sparsity. For each text file, run the algorithm
%       for all beta values in the corresponding vector.
%  reps_cell: [n x 1 cell] Cell array of scalars. For each text file, run the algoritm for this many replications
%        for each of the beta values.
%  ncores: [scalar] number of cores for parallel computation
%  viz_progress: [boolean] visualize the graph during search?
%
function do_search(files_cell,betas_cell,reps_cell,ncores,viz_progress)
       
    % Datasets with this many or more objects are "huge". Search takes
    % a few shortcuts in this case.    
    huge_threshold = 60;   
    
    % -----------------------------------
    
    % Error checking
    ncell = length(files_cell);
    if (ncell ~= length(betas_cell)) || (ncell ~= length(reps_cell))
        error('Lengths of cell arrays "files_cell", "betas_cell", and "reps_cell" must match');
    end
    if ~iscell(files_cell) || ~iscell(betas_cell) || ~iscell(reps_cell)
        error('Must be cell arrays: "files_cell", "betas_cell", and "reps_cell"'); 
    end
    
    % Check to see if all datasets can be loaded
    for i=1:ncell
       fprintf(1,'Checking set %d\n',i);
       import_datasets(files_cell{i});
       fprintf(1,'\n');
    end
    
    % Start parallel computing
    parallel_start(ncores);
    
    % Run the different data files
    for i=1:ncell
        fprintf(1,'\nRunning set %d\n',i);
        do_run(files_cell{i},betas_cell{i},reps_cell{i},huge_threshold,viz_progress);
    end    
    
    % End parallel computing
    parallel_end(ncores);
    fprintf(1,'Done running datasets\n'); 
end

% file_data: txt file name
% betas: [k x 1 scalar] try all these beta values
% nreps: [scalar] number of replications
% huge_threshold: (see above)
% viz_progress: (see above)
function do_run(file_data,betas,nreps,huge_threshold,viz_progress)
    
    % Import the datasets
    fns_featdata = import_datasets(file_data);

    nbetas = length(betas);
    for k=1:nbetas
        
        % Set the beta
        b = betas(k);           
    
        % Make output directory if necessary
        folder_out = ['OUT_BETA',num2str(b,2)]; 
        if ~isdir(folder_out), mkdir(folder_out); end

        % Run the datasets
        for i=1:length(fns_featdata)
            fprintf(1,'\nBeta set at %s\n',num2str(b,2));
            process_featdata(fns_featdata{i},b,folder_out,nreps,huge_threshold,viz_progress);
        end
        
    end
        
end

% fn: file name of dataset in 'data/' folder
% beta: [scalar] try this beta value 
% folder_out: [string] name of output folder to store results
% huge_threshold: (see above)
% viz_progress: (see above)
function process_featdata(fn,beta,folder_out,nreps,huge_threshold,viz_progress)

   

    % Load the candidate dataset
    load(['data/',fn],'data','names');
    [n,m] = size(data);
    if n==m, warning(['Dataset ',fn,' is a square matrix and thus may not be features.']); end  
    
    % Rescale the dataset
    data = rescale_data_missing(data);
    
    % Is this a huge dataset?
    bool_hugedata = n >= huge_threshold;
        
    % Do the replications of a dataset
    for r=1:nreps
        
        fprintf(1,['\nRunning ',fn,'; Replication ',num2str(r),'\n']);
        
        % Get the filename for saving
        fn_base = [folder_out,'/',fn,'_results'];
        fn_out = get_next_filename(fn_base);
        
        % Set up the random number generator
        rseed = rng('shuffle');
        
        % Run the search algorithm
        [M,storeM,storeScore,sparam] = search_main(data,names,beta,bool_hugedata,viz_progress);
        
        % Save the results
        save(fn_out,'rseed','M','store*','sparam','data','names','beta','bool_hugedata');
    end
    
end

% Number the filename so we dont over-write
% existing files
function fn_out = get_next_filename(fn_base)
    r=1;
    fn_out = [fn_base,num2str(r),'.mat'];
    while exist(fn_out,'file')
        r = r + 1;
        fn_out = [fn_base,num2str(r),'.mat'];
    end
end