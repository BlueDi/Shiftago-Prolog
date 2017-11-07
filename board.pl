?- use_module(library(lists)).

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

check_no_moves([]).
check_no_moves([Line|Other_lines]):-
	nonmember('e', Line),
	check_no_moves(Other_lines).

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

/* Get all moves */
get_moves(Board, Player, AllMoves):-
	length(Board, BoardSize),
	valid_move(Board, Player, bottom, BoardSize, AllMovesBottom),
	valid_move(Board, Player, left, BoardSize, AllMovesLeft),
	valid_move(Board, Player, right, BoardSize, AllMovesRight),
	valid_move(Board, Player, top, BoardSize, AllMovesTop),
	append(AllMovesBottom, AllMovesLeft, AllMovesBottomLeft),
	append(AllMovesBottomLeft, AllMovesRight, AllMovesBottomLeftRight),
	append(AllMovesBottomLeftRight, AllMovesTop, AllMoves).
	
valid_move(_, _, _, 0, _).
valid_move(Board, Player, Cardinal, Value, [Cardinal-Value|Other_Moves]):-
	place_piece(Board, Player, Cardinal, Value, NewBoard),
	Board \= NewBoard,
	Value2 is Value - 1,
	valid_move(Board, Player, Cardinal, Value2, Other_Moves).
valid_move(Board, Player, Cardinal, Value, AllMoves):-
	place_piece(Board, Player, Cardinal, Value, Board),
	Value2 is Value - 1,
	valid_move(Board, Player, Cardinal, Value2, AllMoves).
	
/* Board Value */
value(Player, Board, Value):-
	winner(Board, Winner),
	Winner == Player,
	Value is 100.
value(Player, Board, Value):-
	switch_player(Player, NextPlayer),
	winner(Board, Winner),
	Winner == NextPlayer,
	Value is 100.
value(Player, Board, Value):-
	count_pairs_inlines(Player, Board, Value2),
	count_pairs_incolumns(Player, Board, Value3),
	Value is Value2 + Value3.

highest_value_move(Player, Board, Cardinal, Position):-
	get_moves(Board, Player, AllMoves),
	list_value_move(Board, Player, AllMoves, ValueMove),
	sort(ValueMove, SortedValueMove),
	last(SortedValueMove, Value-Cardinal-Position),
	write('Valor do tabuleiro '), write(Value), nl.
	
list_value_move(_, _, [], []).
list_value_move(Board, Player, [Cardinal-Position|AllMoves], [Value-Cardinal-Position|ValueMove]):-
	place_piece(Board, Player, Cardinal, Position, NewBoard),
	value(Player, NewBoard, Value),
	list_value_move(Board, Player, AllMoves, ValueMove).

/**
	Counts the number of pairs by lines.
*/
count_pairs_inlines(_, [], 0).
count_pairs_inlines(Player, [Line|Other_lines], Value):-
	count_pairs_inline(Player, Line, LineValue),
	count_pairs_inlines(Player, Other_lines, Value2),
	Value is Value2 + LineValue.
	
/**
	Counts the number of pairs in a line.
*/
count_pairs_inline(_, [], 0).
count_pairs_inline(X, [Y], 0):-
	X \= Y.
count_pairs_inline(X, [X], 0).
count_pairs_inline(X, [X|[Y|Lista]], N):-
	X \= Y,
	count_pairs_inline(X, Lista, N).
count_pairs_inline(X, [Y|[Z|Lista]], N):-
	X \= Y,
	X \= Z,
	count_pairs_inline(X, Lista, N).
count_pairs_inline(X, [Y|[X|Lista]], N):-
	X \= Y,
	count_pairs_inline(X, [X|Lista], N).
count_pairs_inline(X, [X|[X|Lista]], N):-
	count_pairs_inline(X, [X|Lista], N1),
	N is N1 + 1.
	
/**
	Counts the number of pairs by columns.
*/
count_pairs_incolumns(Player, [Head1|[Head2|[]]], Value):-
	count_pairs_incolumn(Player, Head1, Head2, Value).
count_pairs_incolumns(Player, [Head1|[Head2|Other_Lines]], Value):-
	count_pairs_incolumn(Player, Head1, Head2, Value2),
	count_pairs_incolumns(Player, [Head2|Other_Lines], Value3),
	Value is Value2 + Value3.

/**
	Counts the number of pairs in two columns.
*/
count_pairs_incolumn(_, [], [], 0).
count_pairs_incolumn(Player, [Player|Tail1], [Player|Tail2], Value):-
	count_pairs_incolumn(Player, Tail1, Tail2, Value2),
	Value is Value2 + 1.
count_pairs_incolumn(Player, [Head1|Tail1], [Head2|Tail2], Value):-
	(Player \= Head1; Player \= Head2),
	count_pairs_incolumn(Player, Tail1, Tail2, Value).
