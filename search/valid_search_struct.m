% Returns true if M is a valid structure 
% in "search" form
function val = valid_search_struct(M)

    val = true;
    uclust = unique(M.ci);
    maxclust = max(M.ci);
    if ~isequal(uclust(:),vec(1:maxclust))
        val = false;
        fprintf(1,'** Invalid cluster indices\n');
        return
    end
    
    nclust = maxclust;
    if ~isequal([nclust nclust],size(M.WK))
        val = false;
        fprintf(1,'** Invalid weight dimension\n');
        return
    end
    
    if ~isequal([nclust nclust],size(M.SK))
        val = false;
        fprintf(1,'**Invalid sparsity dimension\n');
        return
    end

    if ~islogical(M.SK)
        val = false;
        fprintf(1,'**Sparsity matrix not logical\n');
        return
    end
    
    spat = M.SK;
    wzero = M.WK(~spat);
    
    if ~aeq(sum(wzero),0)
        val = false;
        fprintf(1,'**Sparsity matrix does not match weights\n');
        return
    end

    if any(M.WK(M.SK) < 0)
        val = false;
        fprintf(1,'**Negative weights\n');
        return
    end
    
end