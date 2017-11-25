:- use_module(library(random)).

:- include('objects.pl').
:- include('board.pl').
:- include('game.pl').
:- include('value.pl').

% Initializes parameters of the game and starts it
shiftago(Winner):-
	nl,
	write(' _____ _     _  __ _ '), nl,
	write('/  ___| |   (_)/ _| |'), nl,
	write('\\ `--.| |__  _| |_| |_ __ _  __ _  ___  '), nl,
	format(" `--. \\ '_ \\| |  _| __/ _` |/ _` |/ _ \\ ", []), nl,
	write('/\\__/ / | | | | | | || (_| | (_| | (_) |'), nl,
	write('\\____/|_| |_|_|_|  \\__\\__,_|\\__, |\\___/ '), nl,
	write('                             __/ |      '), nl,
	write('                            |___/      '), nl, nl,
	write('Please pick a board to play [normal, big, mini]'), nl,
	read(BoardName),
	((BoardName = 'normal', board(Board)); (BoardName = 'big', bigboard(Board)); (BoardName = 'mini', miniboard(Board))),
	
	write('Please pick a game mode: CPU vs CPU, Human vs CPU, Human vs Human [cc, hc, hh]'), nl,
	read(GameMode),
	(GameMode = 'cc'; GameMode = 'hc'; GameMode = 'hh'),
	
	write('Please pick the number of players [2, 3, 4]'), nl,
	read(NPlayers),
	(NPlayers = 2; NPlayers = 3; NPlayers = 4),
	
	((GameMode == 'hh', Difficulty = 'easy');
	write('Please pick difficulty level: Hard or Easy [hard, easy]'), nl,
	read(Difficulty),
	(Difficulty = 'hard'; Difficulty = 'easy')),
	nl,
	
	play(Board, GameMode, NPlayers, Difficulty, Winner, p1).

% Start the game
play(Board, GameMode, NPlayers, Difficulty, Winner, Player):-
	display_board(Board),
	
	nl, write('Player '), write(Player), format("'s turn", []), nl,
	length(Board, BoardSize),
	
	process_turn(GameMode, NPlayers, Difficulty, Player, Board, BoardSize, Cardinal, Position),
	
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
		(switch_player(Player, NewPlayer, NPlayers), play(NewBoard, GameMode, NPlayers, Difficulty, Winner, NewPlayer))
	).

% Choose the mode of turn
process_turn(cc, NPlayers, Difficulty, Player, Board, BoardSize, Cardinal, Position):-
	get_move(NPlayers, Difficulty, Player, Board, BoardSize, Cardinal, Position).
process_turn(hc, NPlayers, Difficulty, Player, Board, BoardSize, Cardinal, Position):-
	(Player == 'p1' ->
		get_move(Player, Board, BoardSize, Cardinal, Position);
		get_move(NPlayers, Difficulty, Player, Board, BoardSize, Cardinal, Position)
	).
process_turn(hh, _, _, Player, Board, BoardSize, Cardinal, Position):-
	get_move(Player, Board, BoardSize, Cardinal, Position).
	
/* Human Turn */
get_move(Player, Board, BoardSize, Cardinal, Position):-
	cardinal_moves(AllCardinals),
	get_moves(Board, Player, AllMoves),
	show_all_moves(AllMoves),
	repeat,
		write('Please pick a side [top, left, right, bottom]'), nl,
		read(Cardinal), 
		write('Please pick a position [1, '), write(BoardSize), write(']'), nl,
		read(Position),
		valid_input(BoardSize, AllMoves, AllCardinals, Cardinal, Position);
		(nl, write('Input ['), write(Cardinal-Position), write('] is not valid.'), nl, fail).
			
/* CPU Easy Turn */
get_move(_, easy, Player, Board, BoardSize, Cardinal, Position):-
	cardinal_moves(AllCardinals),
	random_member(Cardinal, AllCardinals),
	BoardSize1 is BoardSize + 1,
	random(1, BoardSize1, Position),
	get_moves(Board, Player, AllMoves),
	member(Cardinal-Position, AllMoves).

/* CPU Hard Turn */
get_move(NPlayers, hard, Player, Board, _, Cardinal, Position):-
	highest_value_move(NPlayers, Player, Board, Cardinal, Position).
	
% Checks if the input was valid
valid_input(BoardSize, AllMoves, AllCardinals, Cardinal, Position):-
	member(Cardinal, AllCardinals), 
	integer(Position), 
	Position =< BoardSize, 
	Position > 0, 
	member(Cardinal-Position, AllMoves).

% Writes all the valid moves of the player
show_all_moves(ValidMoves):-
	write('Valid Moves:'), nl,
	show_all_move(ValidMoves),
	nl.
show_all_move([]).
show_all_move([Move|Other_Moves]) :-
	write('    '), write(Move), nl,
	show_all_move(Other_Moves).
