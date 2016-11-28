% Do structure learning for the current model
%
% Input
%   M: [struct] the model
%   sparam: [struct] search parameters
%
% Other: 'clean_restarts',true, does multiple random restarts
function M = search_learn_structure(M,sparam,varargin)

    bool_clean_restarts = false;
    for i = 1:2:length(varargin)
        switch varargin{i}
            case 'clean_restarts', bool_clean_restarts = varargin{i+1};
            otherwise, error('invalid argument');
        end
    end
    assert(islogical(bool_clean_restarts));    
    
    if bool_clean_restarts % Do several random restarts
        S = cell(sparam.nrestart_slearn,1);
        parfor i=1:sparam.nrestart_slearn
           S{i} = search_learn_structural_EM(M,sparam,bool_clean_restarts);
        end
        M = search_pick_best(S);
    else % Use current attachment weights and set other weights to 0
        M = search_learn_structural_EM(M,sparam,bool_clean_restarts);
    end
       
end