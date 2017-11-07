/** 
	Returns the highest value move 
		get_moves needs AllMoves to be a list of Cardinal-Position
*/
highest_value_move(NPlayers, Player, Board, Cardinal, Position):-
	get_moves(Board, Player, AllMoves),
	list_value_move(Board, NPlayers, Player, AllMoves, ValueMove),
	sort(ValueMove, SortedValueMove),
	last(SortedValueMove, _-Cardinal-Position).

/* Value of the Board */
value(_, Player, Board, Value):-
	winner(Board, Winner),
	Winner == Player,
	Value is 100.
value(NPlayers, Player, Board, Value):-
	switch_player(Player, NextPlayer, NPlayers),
	winner(Board, Winner),
	Winner == NextPlayer,
	Value is 100.
value(NPlayers, Player, Board, Value):-
	count_pairs_inlines(Player, Board, Value2),
	count_pairs_incolumns(Player, Board, Value3),
	count_around_player(Board, Player, Value4),
	switch_player(Player, NextPlayer, NPlayers),
	count_pairs_inlines(NextPlayer, Board, EnemyValue2),
	count_pairs_incolumns(NextPlayer, Board, EnemyValue3),
	count_around_player(Board, NextPlayer, EnemyValue4),
	PlayerValue is (3 * Value2) + (3 * Value3) + Value4,
	EnemyValue is (3 * EnemyValue2) + (3 * EnemyValue3) + EnemyValue4,
	Value is PlayerValue - EnemyValue.

/** 
	Creates a list with all the valid moves and their value
		Format of the list: Value-Cardinal-Position
*/
list_value_move(_, _, _, [], []).
list_value_move(Board, NPlayers, Player, [Cardinal-Position|AllMoves], [Value-Cardinal-Position|ValueMove]):-
	place_piece(Board, Player, Cardinal, Position, NewBoard),
	value(NPlayers, Player, NewBoard, Value),
	list_value_move(Board, NPlayers, Player, AllMoves, ValueMove).

/* Counters */
% Counts the number of pairs by lines
count_pairs_inlines(_, [], 0).
count_pairs_inlines(Player, [Line|Other_lines], Value):-
	count_pairs_inline(Player, Line, LineValue),
	count_pairs_inlines(Player, Other_lines, Value2),
	Value is Value2 + LineValue.
	
% Counts the number of pairs in a line 
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
	
% Counts the number of pairs by columns
count_pairs_incolumns(Player, [Head1|[Head2|[]]], Value):-
	count_pairs_incolumn(Player, Head1, Head2, Value).
count_pairs_incolumns(Player, [Head1|[Head2|Other_Lines]], Value):-
	count_pairs_incolumn(Player, Head1, Head2, Value2),
	count_pairs_incolumns(Player, [Head2|Other_Lines], Value3),
	Value is Value2 + Value3.

% Counts the number of pairs in two columns
count_pairs_incolumn(_, [], [], 0).
count_pairs_incolumn(Player, [Player|Tail1], [Player|Tail2], Value):-
	count_pairs_incolumn(Player, Tail1, Tail2, Value2),
	Value is Value2 + 1.
count_pairs_incolumn(Player, [Head1|Tail1], [Head2|Tail2], Value):-
	(Player \= Head1; Player \= Head2),
	count_pairs_incolumn(Player, Tail1, Tail2, Value).
	
% Counts the number of player pieces around every piece of a player
count_around_player(Board, Player, Value):-
	get_player_pieces(Board, Player, Pieces),
	count_arounds(Pieces, Value).

count_arounds([], 0).
count_arounds([Y-X|Pieces], Value):-
	count_around([Y-X|Pieces], Y-X, ValueP),
	count_arounds(Pieces, ValueO),
	Value is ValueP + ValueO.
	
count_around([], _, 0).
count_around([Y2-X2|Pieces], Y1-X1, Value):-
	X1 > X2 - 1,
	Y1 > Y2 - 1,
	X1 < X2 + 1,
	Y1 < Y2 + 1,
	count_around(Pieces, Y1-X1, Value2),
	Value is Value2 + 1.
count_around([Y2-X2|Pieces], Y1-X1, Value):-
	(X1 =< X2 - 1;
	Y1 =< Y2 - 1;
	X1 >= X2 + 1;
	Y1 >= Y2 + 1),
	count_around(Pieces, Y1-X1, Value).

/**
	Get all of the player pieces 
		Format: List of Y-X
*/
get_player_pieces(Board, Player, Pieces):-
	get_player_pieces(Board, Player, 1, Pieces).
get_player_pieces([], _, _, []).
get_player_pieces([Line|Tail], Player, Y, PlayerPieces):-
	get_player_pieces_line(Line, Player, 1, Y, LinePieces),
	Y1 is Y + 1,
	get_player_pieces(Tail, Player, Y1, Pieces),
	append(LinePieces, Pieces, PlayerPieces).

% Get the players pieces of a line
get_player_pieces_line([], _, _, _, []).
get_player_pieces_line([Player|Tail], Player, X, Y, [Y-X|Pieces]):-
	X1 is X + 1,
	get_player_pieces_line(Tail, Player, X1, Y, Pieces).
get_player_pieces_line([NotPlayer|Tail], Player, X, Y, Pieces):-
	NotPlayer \= Player,
	X1 is X + 1,
	get_player_pieces_line(Tail, Player, X1, Y, Pieces).