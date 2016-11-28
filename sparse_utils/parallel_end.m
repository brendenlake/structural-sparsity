% End matlab parallel job
function parallel_end(ncores)
    if ncores > 1
        matlabpool close;
    end
end