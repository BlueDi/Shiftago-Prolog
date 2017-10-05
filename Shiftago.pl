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

% Colocar peca
place_piece(Board, Player, left, Y, NewBoard):-
	miniboard(Board),
	search_Y(Board, Player, Y, NewBoard),
	display_board(NewBoard).
place_piece(Board, Player, right, Y, NewBoard):-
	miniboard(Board),
	search_Y(Board, Player, Y, NewBoard),
	display_board(NewBoard).
	
search_Y([[]|[]], _, _, _).
search_Y([Head|Tail], Player, Y, [Head|NewTail]):-
	Y > 1,
	Y1 is Y - 1,
	search_Y(Tail, Player, Y1, NewTail).
search_Y([Linha|Cauda], Player, 1, NewBoard):-
	delete_free_space(Linha, LinhaIntermedia), % Verificar se tem uma posicao livre na linha
	append([Player], LinhaIntermedia, NovaLinha), % Construir a nova linha
	substituir_linha(NovaLinha, [Linha|Cauda], NewBoard).
	
substituir_linha(Linha, [AEliminar|Tail], Resultado):-
	append(La, [AEliminar|Lb], [AEliminar|Tail]),
	append(La, Lb, BoardIntermedio),
	append([Linha], BoardIntermedio, Resultado),
	length(AEliminar, SizeCheck),
	length(AEliminar, SizeCheck).

delete_free_space(ListaOriginal, ListaFinal):-
	append(La, [e|Lb], ListaOriginal),
	append(La, Lb, ListaFinal).
