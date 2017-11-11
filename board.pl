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

/** Place a piece on the board */
place_piece(Board, Player, left, Y, NewBoard):-
	(check_valid_y(Board, Y),
	place_y(Board, Player, Y, NewBoard),
	check_board(Board, NewBoard));
	NewBoard = Board.
place_piece(Board, Player, right, Y, NewBoard):-
	(check_valid_y(Board, Y),
	invert_board_horizontal(Board, InvBoard),
	place_y(InvBoard, Player, Y, ReInvBoard),
	invert_board_horizontal(ReInvBoard, NewBoard),
	check_board(Board, NewBoard));
	NewBoard = Board.
place_piece(Board, Player, top, X, NewBoard):-
	(check_valid_x(Board, X),
	place_x(Board, Player, X, NewBoard),
	check_board(Board, NewBoard));
	NewBoard = Board.
place_piece(Board, Player, bottom, X, NewBoard):-
	(check_valid_x(Board, X),
	invert(Board, InvBoard),
	place_x(InvBoard, Player, X, ReInvBoard),
	invert(ReInvBoard, NewBoard),
	check_board(Board, NewBoard));
	NewBoard = Board.

/* Invert */
% Invert the Board
invert_board_horizontal([], _).
invert_board_horizontal([Line|Resto], [InvLine|InvResto]):-
	invert(Line, InvLine),
	invert_board_horizontal(Resto, InvResto).

% invert a list
invert(Lista, InvLista):-
	invert_(Lista, [], InvLista).
invert_([H|T], S, R):-
	invert_(T, [H|S], R).
invert_([], R, R).

/**
	Places the piece left or right of the board.
		Looks up for the Y line.
		Checks if it has an empty space.
		If it has then adds to the beggining the Player piece and pushes the other pieces.
		Else ignores.
*/
place_y([[]|[]], _, _, _).
place_y([Head|Tail], Player, Y, [Head|NewTail]):-
	Y > 1,
	Y1 is Y - 1,
	place_y(Tail, Player, Y1, NewTail).
place_y([Line|Tail], Player, 1, NewBoard):-
	delete_free_space(Line, LineI), % Verificar se tem uma posicao livre na linha
	append([Player], LineI, NewLine), % Construir a nova linha
	replace_line(NewLine, [Line|Tail], NewBoard).

% In a list, removes one 'e'
delete_free_space(Original, Final):-
	append(La, [e|Lb], Original),
	append(La, Lb, Final).

% In a list of lists, replace the head list with another
replace_line(Line, [ToRemove|Tail], Final):-
	append(La, [ToRemove|Lb], [ToRemove|Tail]),
	append(La, Lb, BoardI),
	append([Line], BoardI, Final).

/**
	Places the piece top or bottom of the board.
		Replaces the X position of the list with Player and saves the old piece at that position.
		For every line changes the X position to the old piece of the previous line.
		Stops when it finds an empty space or the end of the board.
*/
place_x([[]|[]], _, _, _).
place_x(Board, e, _, Board).
place_x([Head|Tail], Player, X, [NewHead|NewTail]):-
	replace_nth(X, Head, Player, NewHead, NewPiece),
	place_x(Tail, NewPiece, X, NewTail).

% Replace the nth element
replace_nth(1, [e|Tail], NewPiece, [NewPiece|Tail], e).
replace_nth(1, [OldPiece|Tail], NewPiece, [NewPiece|Tail], OldPiece):-
	OldPiece \= e.
replace_nth(Nth, [Head|Tail], NewPiece, [Head|NewTail], OldPiece):-
	Nth > 1,
	N1 is Nth - 1,
	replace_nth(N1, Tail, NewPiece, NewTail, OldPiece).

/** Get all moves */
get_moves(Board, Player, AllMoves):-
	length(Board, BoardSize),
	valid_move(Board, Player, bottom, BoardSize, AllMovesBottom),
	valid_move(Board, Player, left, BoardSize, AllMovesLeft),
	valid_move(Board, Player, right, BoardSize, AllMovesRight),
	valid_move(Board, Player, top, BoardSize, AllMovesTop),
	append(AllMovesBottom, AllMovesLeft, AllMovesBottomLeft),
	append(AllMovesBottomLeft, AllMovesRight, AllMovesBottomLeftRight),
	append(AllMovesBottomLeftRight, AllMovesTop, AllMoves).

/* Checks */
% Check if a move is valid
valid_move(_, _, _, 0, _).
valid_move(Board, Player, Cardinal, Position, [Cardinal-Position|Other_Moves]):-
	place_piece(Board, Player, Cardinal, Position, NewBoard),
	Board \= NewBoard,
	Position2 is Position - 1,
	valid_move(Board, Player, Cardinal, Position2, Other_Moves).
valid_move(Board, Player, Cardinal, Position, AllMoves):-
	place_piece(Board, Player, Cardinal, Position, Board),
	Position2 is Position - 1,
	valid_move(Board, Player, Cardinal, Position2, AllMoves).
	
% Check if the board didn't chang the number of lines
check_board(Board, NewBoard):-
	length(Board, BoardCheck),
	length(NewBoard, BoardCheck).

% Check if there isn't more moves for any player
check_no_moves([]).
check_no_moves([Line|Other_lines]):-
	nonmember('e', Line),
	check_no_moves(Other_lines).

% Checks if Y is Valid
check_valid_y(Board, Y):-
	length(Board, BoardCheck),
	Y =< BoardCheck,
	Y > 0.
	
% Check if X is valid
check_valid_x([Line|_], X):-
	length(Line, BoardCheck),
	X =< BoardCheck,
	X > 0.
