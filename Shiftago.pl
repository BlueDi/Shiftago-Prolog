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
	[p2, e, e],
	[e, e, e]
]).
	
/* Symbols */
translate(e, 'O').
translate(p1, '1').
translate(p2, '2').

/* Display */
display_board([Line | []]):-
	display_board_line_pieces(Line),
	write('\n').
display_board([Line | Other_lines]):-
	display_board_line_pieces(Line), 
	nl, 
	display_board_line_nopieces(Line), 
	nl, 
	display_board(Other_lines).

% Display linhas com pecas
display_board_line_pieces([Piece | []]):-
	translate(Piece, Symbol),
	write(Symbol).
display_board_line_pieces([Piece | Other_pieces]):-
	translate(Piece, Symbol),
	write(Symbol),
	write(' - '), 
	display_board_line_pieces(Other_pieces).
	
% Display linhas sem pecas
display_board_line_nopieces([_ | []]):-
	write('|').
display_board_line_nopieces([_ | Other_pieces]):-
	write('|'), 
	write('   '), 
	display_board_line_nopieces(Other_pieces).
	
% Checkers
checkBoard(Board, NewBoard):-
	length(Board, BoardCheck),
	length(NewBoard, BoardCheck).
	
checkValidY(Board, Y):-
	length(Board, BoardCheck),
	Y =< BoardCheck.
	
% Main
play(normal):-
	board(Board),
	place_piece(Board, p1, left, 2, Board2),
	place_piece(Board2, p2, right, 2, Board3),
	place_piece(Board3, p1, right, 6, Board4),
	place_piece(Board4, p2, right, 2, NewBoard),
	display_board(NewBoard).
play(mini):-
	miniboard(Board),
	place_piece(Board, p1, left, 2, Board2),
	place_piece(Board2, p2, right, 2, Board3),
	place_piece(Board3, p1, right, 6, Board4),
	place_piece(Board4, p2, right, 2, NewBoard),
	display_board(NewBoard).

% Colocar peca
place_piece(Board, Player, left, Y, NewBoard):-
	(checkValidY(Board, Y),
	place_Y(Board, Player, Y, NewBoard),
	checkBoard(Board, NewBoard));
	NewBoard = Board.
place_piece(Board, Player, right, Y, NewBoard):-
	(checkValidY(Board, Y),
	inverterBoard(Board, InvBoard),
	place_Y(InvBoard, Player, Y, ReInvBoard),
	inverterBoard(ReInvBoard, NewBoard),
	checkBoard(Board, NewBoard));
	NewBoard = Board.
	
place_Y([[]|[]], _, _, _).
place_Y([Head|Tail], Player, Y, [Head|NewTail]):-
	Y > 1,
	Y1 is Y - 1,
	place_Y(Tail, Player, Y1, NewTail).
place_Y([Linha|Cauda], Player, 1, NewBoard):-
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

inverterBoard([], _).
inverterBoard([Linha|Resto], [InvLinha|InvResto]):- % Inverte o tabuleiro na Horizontal
	inverterLista(Linha, InvLinha),
	inverterBoard(Resto, InvResto).
	
inverterLista(Lista, InvLista):-
	rev(Lista, [], InvLista).
rev([H|T], S, R):-
	rev(T, [H|S], R).
rev([], R, R).