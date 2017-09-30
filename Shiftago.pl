/* Board */
board([
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e]
	]).

/* Display */
% To run: display_board(board).
display_board(board) :-
	board(Board),
	display_board(Board).
display_board([Line | []]) :-
	display_board_line_pieces(Line).
display_board([Line | Other_lines]) :-
	display_board_line_pieces(Line), 
	nl, 
	display_board_line_nopieces(Line), 
	nl, 
	display_board(Other_lines).

% Display linhas com pecas
display_board_line_pieces([Piece | []]) :-
	write(Piece).
display_board_line_pieces([Piece | Other_pieces]) :-
	write(Piece), 
	write(' - '), 
	display_board_line_pieces(Other_pieces).
	
% Display linhas sem pecas
display_board_line_nopieces([Piece | []]) :-
	write('|').
display_board_line_nopieces([Piece | Other_pieces]) :-
	write('|'), 
	write('   '), 
	display_board_line_nopieces(Other_pieces).
