/* Display */
display_board([Line | []]):-
	display_board_line_pieces(Line),
	nl.
display_board([Line | Other_lines]):-
	display_board_line_pieces(Line), 
	nl, 
	display_board_line_nopieces(Line), 
	nl, 
	display_board(Other_lines).

% Display lines with pieces
display_board_line_pieces([Piece | []]):-
	translate(Piece, Symbol),
	write(Symbol).
display_board_line_pieces([Piece | Other_pieces]):-
	translate(Piece, Symbol),
	write(Symbol),
	write(' - '), 
	display_board_line_pieces(Other_pieces).
	
% Display lines without pieces
display_board_line_nopieces([_ | []]):-
	write('|').
display_board_line_nopieces([_ | Other_pieces]):-
	write('|'), 
	write('   '), 
	display_board_line_nopieces(Other_pieces).
	
/* Checks */
checkBoard(Board, NewBoard):-
	length(Board, BoardCheck),
	length(NewBoard, BoardCheck).

checkValidY(Board, Y):-
	length(Board, BoardCheck),
	Y =< BoardCheck.
	
checkValidX([Line|_], X):-
	length(Line, BoardCheck),
	X =< BoardCheck.

/* Place a piece */
place_piece(Board, Player, left, Y, NewBoard):-
	(checkValidY(Board, Y),
	place_Y(Board, Player, Y, NewBoard),
	checkBoard(Board, NewBoard));
	NewBoard = Board.
place_piece(Board, Player, right, Y, NewBoard):-
	(checkValidY(Board, Y),
	invertBoardHorizontal(Board, InvBoard),
	place_Y(InvBoard, Player, Y, ReInvBoard),
	invertBoardHorizontal(ReInvBoard, NewBoard),
	checkBoard(Board, NewBoard));
	NewBoard = Board.
place_piece(Board, Player, top, X, NewBoard):-
	(checkValidX(Board, X),
	place_X(Board, Player, X, NewBoard),
	checkBoard(Board, NewBoard));
	NewBoard = Board.
place_piece(Board, Player, bottom, X, NewBoard):-
	(checkValidX(Board, X),
	inverts(Board, InvBoard),
	place_X(InvBoard, Player, X, ReInvBoard),
	inverts(ReInvBoard, NewBoard),
	checkBoard(Board, NewBoard));
	NewBoard = Board.

% Invert Board
invertBoardHorizontal([], _).
invertBoardHorizontal([Linha|Resto], [InvLinha|InvResto]):-
	inverts(Linha, InvLinha),
	invertBoardHorizontal(Resto, InvResto).

inverts(Lista, InvLista):-
	inverts_(Lista, [], InvLista).
inverts_([H|T], S, R):-
	inverts_(T, [H|S], R).
inverts_([], R, R).

/**
	Places the piece left or right of the board.
		Looks up for the Y line.
		Checks if it has an empty space.
		If it has then adds to the beggining the Player piece and pushes the other pieces.
		Else ignores.
*/
place_Y([[]|[]], _, _, _).
place_Y([Head|Tail], Player, Y, [Head|NewTail]):-
	Y > 1,
	Y1 is Y - 1,
	place_Y(Tail, Player, Y1, NewTail).
place_Y([Linha|Cauda], Player, 1, NewBoard):-
	delete_free_space(Linha, LinhaIntermedia), % Verificar se tem uma posicao livre na linha
	append([Player], LinhaIntermedia, NovaLinha), % Construir a nova linha
	replace_line(NovaLinha, [Linha|Cauda], NewBoard).

delete_free_space(ListaOriginal, ListaFinal):-
	append(La, [e|Lb], ListaOriginal),
	append(La, Lb, ListaFinal).

replace_line(Linha, [AEliminar|Tail], Resultado):-
	append(La, [AEliminar|Lb], [AEliminar|Tail]),
	append(La, Lb, BoardIntermedio),
	append([Linha], BoardIntermedio, Resultado),
	length(AEliminar, SizeCheck),
	length(AEliminar, SizeCheck).

/**
	Places the piece top or bottom of the board.
		Replaces the X position of the list with Player and saves the old piece at that position.
		For every line changes the X position to the old piece of the previous line.
		Stops when it finds an empty space or the end of the board.
*/
place_X([[]|[]], _, _, _).
place_X(Board, e, _, Board).
place_X([Head|Tail], Player, X, [NewHead|NewTail]):-
	replace_nth(X, Head, Player, NewHead, NovaPeca),
	place_X(Tail, NovaPeca, X, NewTail).

replace_nth(1, [e|Tail], NovaPeca, [NovaPeca|Tail], e).
replace_nth(1, [VelhaPeca|Tail], NovaPeca, [NovaPeca|Tail], VelhaPeca):-
	VelhaPeca \= e.
replace_nth(Nth, [Head|Tail], NovaPeca, [Head|NewTail], VelhaPeca):-
	Nth > 1,
	N1 is Nth - 1,
	replace_nth(N1, Tail, NovaPeca, NewTail, VelhaPeca).