% Start Matlab parallel job with this many scores (nscores)
function parallel_start(ncores)
    if matlabpool('size') > 0
        matlabpool close;
    end
    if ncores > 1
        fprintf(1,'Running jobs in parallel\n');
        matlabpool('open','local',ncores);
    elseif isempty(ncores) || isnan(ncores) || nargin < 1
        matlabpool('open','local');
    elseif ncores == 1
        fprintf(1,'Running jobs in serial\n');
    else
        error('Number of cores not properly specified'); 
    end
end