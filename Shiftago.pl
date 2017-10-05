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

miniboard([
	[p1, p2, p1],
	[e, e, e],
	[e, e, e]
]).
	
/* Symbols */
translate(e, 'O').
translate(p1, '1').
translate(p2, '2').

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
	translate(Piece, Symbol),
	write(Symbol).
display_board_line_pieces([Piece | Other_pieces]) :-
	translate(Piece, Symbol),
	write(Symbol),
	write(' - '), 
	display_board_line_pieces(Other_pieces).
	
% Display linhas sem pecas
display_board_line_nopieces([_ | []]) :-
	write('|').
display_board_line_nopieces([_ | Other_pieces]) :-
	write('|'), 
	write('   '), 
	display_board_line_nopieces(Other_pieces).
