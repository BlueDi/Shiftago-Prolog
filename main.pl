:- use_module(library(random)).

:- include('objects.pl').
:- include('board.pl').
:- include('game.pl').

shiftago(Winner):-
	write('Please pick a board to play [normal, mini]'), nl,
	read(BoardName),
	((BoardName = 'normal', board(Board)); (BoardName = 'mini', miniboard(Board))),
	
	write('Please pick a game mode: CPU vs CPU, Human vs CPU, Human vs Human [cc, hc, hh]'), nl,
	read(GameMode),
	(GameMode = 'cc'; GameMode = 'hc'; GameMode = 'hh'),
	
	play(Board, GameMode, Winner, p1).

play(Board, GameMode, Winner, Player):-
	display_board(Board),	
	
	nl, write('Player '), write(Player), write("'s turn"), nl,
	length(Board, BoardSize),
	
	process_turn(GameMode, BoardSize, Cardinal, Position, Player),
	
	/*
	(	%  Como default chama o get_move para humanos em todos os casos exceto quando é CPU vs CPU
		% ou quando se trata do p2 num jogo Human vs CPU
		GameMode == 'hh' ->
		(get_move(h, BoardSize, Cardinal, Position);
			(
				GameMode == 'hc' ->
				(
					Player == p1 ->
					(
						get_move(h, BoardSize, Cardinal, Position);
						get_move(c, BoardSize, Cardinal, Position)
					)
				)
			)
		)
	),
	*/
	
	write(Player), write(' placing at '), write(Cardinal), write(', '), write(Position), nl,
	place_piece(Board, Player, Cardinal, Position, NewBoard),
	
	/* check end condition */
	winner(NewBoard, TempWinner),
	nl, write('Winner = '), write(TempWinner), nl, nl,
	(
		 (TempWinner \= 'none'; check_no_moves(NewBoard)) ->
			(
				Winner = TempWinner,
				write('------- GAME OVER -------'), nl, nl,
				display_board(NewBoard),
				nl, write('------- GAME OVER -------')
			);
			(switch_player(Player, NewPlayer), play(NewBoard, GameMode, Winner, NewPlayer))
	).

process_turn(cc, BoardSize, Cardinal, Position, _):-
	get_move(c, BoardSize, Cardinal, Position).
	
% Assume-se que o Player2 num jogo Human vs CPU é sempre o CPU
process_turn(hc, BoardSize, Cardinal, Position, Player):-
	(get_move(h, BoardSize, Cardinal, Position), Player \= 'p2');
	get_move(c, BoardSize, Cardinal, Position).
	
process_turn(hh, BoardSize, Cardinal, Position, _):-
	get_move(h, BoardSize, Cardinal, Position).
	
get_move(h, BoardSize, Cardinal, Position):-
	repeat,
	write('Please pick a side [top, left, right, bottom]'), nl,
	read(Cardinal), 
	cardinal_moves(AllCardinals),
	(member(Cardinal, AllCardinals) ->
			!;
			write('\nInput '), write(Cardinal), write(' is not valid.\n'),
			fail
	),
	
	write('Please pick a position [1, '), write(BoardSize), write(']\n'),
	read(Position). % TODO: Check if Position is valid
	
get_move(c, BoardSize, Cardinal, Position):-
	cardinal_moves(AllCardinals),
	random_member(Cardinal, AllCardinals),
	BoardSize1 is BoardSize + 1,
	random(1, BoardSize1, Position).
