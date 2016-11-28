% Analyze multiple replications of a dataset
%
% Input
%   dir: directory where files are
%   fn_base: name of the dataset (animals,colors,etc.)
%   varagin: this is passed directly to displayS function
%
% Output
%  M: the best structure
%
function M = analyze_main_results(dir,fn_base,varargin)
    r = 1;
    fn = [dir,'/',fn_base,'_results',num2str(r),'.mat'];
    
    % Get the score for each replication
    store_reps = [];
    while exist(fn,'file')
       load(fn);
       this_score = grandscore(make_adj(M),M.data,M.beta,'miss_info',M.miss_info);
       store_reps = [store_reps; this_score];
       r = r + 1;
       fn = [dir,'/',fn_base,'_results',num2str(r),'.mat'];
    end
    if r==1
       error('invalid name'); 
    end
    
    % Plot the best replication
    best_indx = argmax(store_reps);
    fn_best = [dir,'/',fn_base,'_results',num2str(best_indx),'.mat'];
    load(fn_best);
    grandscore(make_adj(M),M.data,M.beta,'miss_info',M.miss_info,'verbose',true);
    displayS(make_adj(M),M.names,varargin{:});
    
    % Plot the other scores
    n = length(store_reps);
    for i=1:n
       fprintf(1,'Score rep %d: %s\n',i,num2str(store_reps(i)));
    end
end