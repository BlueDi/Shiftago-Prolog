:- use_module(library(random)).

:- include('objects.pl').
:- include('board.pl').
:- include('game.pl').
:- include('value.pl').

% Initializes parameters of the game and starts it
shiftago(Winner):-
	write('Please pick a board to play [normal, mini]'), nl,
	read(BoardName),
	((BoardName = 'normal', board(Board)); (BoardName = 'mini', miniboard(Board))),
	
	write('Please pick a game mode: CPU vs CPU, Human vs CPU, Human vs Human [cc, hc, hh]'), nl,
	read(GameMode),
	(GameMode = 'cc'; GameMode = 'hc'; GameMode = 'hh'),
	
	((GameMode == 'hh', Difficulty = 'easy');
	write('Please pick difficulty level: Hard or Easy [hard, easy]'), nl,
	read(Difficulty),
	(Difficulty = 'hard'; Difficulty = 'easy')),
	
	play(Board, GameMode, Difficulty, Winner, p1).

% Start the game
play(Board, GameMode, Difficulty, Winner, Player):-
	display_board(Board),	
	
	nl, write('Player '), write(Player), format("'s turn", []), nl,
	length(Board, BoardSize),
	
	process_turn(GameMode, Difficulty, Board, BoardSize, Cardinal, Position, Player),
	
	write(Player), write(' placing at '), write(Cardinal), write(', '), write(Position), nl,
	place_piece(Board, Player, Cardinal, Position, NewBoard),
	
	/* check end condition */
	winner(NewBoard, TempWinner),
	nl, write('Winner = '), write(TempWinner), nl, nl,
	((TempWinner \= 'none'; check_no_moves(NewBoard)) ->
		(
			Winner = TempWinner,
			write('------- GAME OVER -------'), nl, nl,
			display_board(NewBoard),
			nl, write('------- GAME OVER -------')
		);
		(switch_player(Player, NewPlayer), play(NewBoard, GameMode, Difficulty, Winner, NewPlayer))
	).

% Choose the mode of turn
process_turn(cc, Difficulty, Board, BoardSize, Cardinal, Position, Player):-
	get_move(Difficulty, Board, BoardSize, Cardinal, Position, Player).
process_turn(hc, Difficulty, Board, BoardSize, Cardinal, Position, Player):-
	(Player == 'p1' ->
		get_move(Board, BoardSize, Cardinal, Position, Player);
		get_move(Difficulty, Board, BoardSize, Cardinal, Position, Player)
	).
process_turn(hh, _, Board, BoardSize, Cardinal, Position, Player):-
	get_move(Board, BoardSize, Cardinal, Position, Player).
	
/* Human Turn */
get_move(Board, BoardSize, Cardinal, Position, Player):-
	cardinal_moves(AllCardinals),
	get_moves(Board, Player, AllMoves),
	show_all_moves(AllMoves),
	repeat,
		write('Please pick a side [top, left, right, bottom]'), nl,
		read(Cardinal), 
		write('Please pick a position [1, '), write(BoardSize), write(']'), nl,
		read(Position),
		(	valid_input(BoardSize, AllMoves, AllCardinals, Cardinal, Position)
		->	!
		;	nl, write('Input ['), write(Cardinal-Position), write('] is not valid.'), nl,
			fail
		).

% Checks if the input was valid
valid_input(BoardSize, AllMoves, AllCardinals, Cardinal, Position):-
	member(Cardinal, AllCardinals), 
	integer(Position), 
	Position =< BoardSize, 
	Position > 0, 
	member(Cardinal-Position, AllMoves).
			
/* CPU Easy Turn */
get_move(easy, Board, BoardSize, Cardinal, Position, Player):-
	cardinal_moves(AllCardinals),
	random_member(Cardinal, AllCardinals),
	BoardSize1 is BoardSize + 1,
	random(1, BoardSize1, Position),
	get_moves(Board, Player, AllMoves),
	member(Cardinal-Position, AllMoves).

/* CPU Hard Turn */
get_move(hard, Board, _, Cardinal, Position, Player):-
	highest_value_move(Player, Board, Cardinal, Position).

% Writes all the valid moves of the player
show_all_moves(ValidMoves):-
	write('Valid Moves:'), nl,
	show_all_move(ValidMoves),
	nl.
show_all_move([]).
show_all_move([Move|Other_Moves]) :-
	write('    '), write(Move), nl,
	show_all_move(Other_Moves).
