% Score a structure in search format
function log_score = search_score(M)
    R = search_make_graph_format(M);
    log_score = grandscore(R,M.data,M.beta,'miss_info',M.miss_info);
end