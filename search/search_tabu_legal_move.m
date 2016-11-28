% Does the move described by "s_move" reverse
% any of the moves in the tabu list?
%
% Input
%  s_move: move structure (see search_init_model)
%  sparam: search parameters (has the tabu list inside)
%
% Output
%  is_legal: (boolean) is s_move a legal move?
function is_legal = search_tabu_legal_move(s_move,sparam)
    is_legal = true;
    len = length(sparam.tabu_moves);
    for i=len:-1:1
        if is_reverse_move(s_move,sparam.tabu_moves{i})
            is_legal = false;
            return
        end
    end
end

% Does one move reverse the other?
function is_reverse = is_reverse_move(move1,move2)
    names_match_order1 =  name_cell_match(move1.names1,move2.names1) &&  name_cell_match(move1.names2,move2.names2);
    names_match_order2 =  name_cell_match(move1.names1,move2.names2) &&  name_cell_match(move1.names2,move2.names1);
    type_match = strcmp(move1.type,move2.type);    
    is_reverse = ~type_match && (names_match_order1 || names_match_order2);
end

% Are two cell arrays of strings identical?
function is_match = name_cell_match(names1,names2)
    if length(names1) ~= length(names2)
       is_match = false;
       return
    end
    is_match = all(strcmp(names1,names2));
end