% Add the move "s_move" to the tabu list.
%
% Input
%  s_move: move structure (see search_init_model)
%  sparam: search parameters (has the tabu list inside)
%
% Output
%  sparam: updated parameters
function sparam = search_tabu_add_move(s_move,sparam)
    currlen = length(sparam.tabu_moves);
    sparam.tabu_moves{currlen+1} = s_move;
    
    if currlen == sparam.tabu_moves_length
       sparam.tabu_moves(1) = []; 
    end   
end