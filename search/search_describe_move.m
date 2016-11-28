% Print a description of a move
% to the screen
%
% Input
%  s_move: move structure (see search_init_model);
function search_describe_move(s_move)
    if strcmp(s_move.type,'split')
        fprintf(1,'Split move:\n');        
    elseif strcmp(s_move.type,'merge')
        fprintf(1,'Merge move:\n');
    else
        error('Unknown move type');    
    end
    n1=display_names(s_move.names1);
    n2=display_names(s_move.names2);
    fprintf('  %s\n  %s\n',n1,n2);
end

function str = display_names(names)
    n = length(names);
    str = '{';
    for i=1:n
        str = [str names{i}];
        if i<n
          str = [str ',']; 
        end
    end
    str = [str '}'];
end