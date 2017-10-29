:- use_module(library(random)).

:- include('objects.pl').
:- include('board.pl').
:- include('game.pl').

cardinal_moves([top, left, right, bottom]).

shiftago(Winner):-
	write('Please pick a board to play [normal, mini]'), nl,
	read(BoardName),
	((BoardName = 'normal', board(Board)); (BoardName = 'mini', miniboard(Board))),
	
	write('Please pick a game mode: CPU vs CPU, CPU vs Human, Human vs Human [cc, ch, hh]'), nl,
	read(GameMode),
	(GameMode = 'cc'; GameMode = 'ch'; GameMode = 'hh'),
	
	play(Board, GameMode, Winner, p1).

play(Board, GameMode, Winner, Player):-
	display_board(Board),	
	
	nl, write('Player '), write(Player), write(' turn'), nl,
	length(Board, BoardSize),
	get_move(GameMode, BoardSize, Cardinal, Position),
	place_piece(Board, Player, Cardinal, Position, NewBoard),
	
	/* check end condition */
	winner(NewBoard, Winner),
	nl, write('Winner = '), write(Winner), nl, nl,
	(
		 Winner \= 'none' ->
			(
				write('GAME OVER'), nl, nl
			);
			switch_player(Player, NewPlayer),
			play(NewBoard, GameMode, Winner, NewPlayer)
	).

get_move(hh, BoardSize, Cardinal, Position):-
	write('Please pick a side [top, left, right, bottom]'), nl,
	read(Cardinal), % TODO: Check if Cardinal is valid
	write('Please pick a position [1, Board_Size]'), nl,
	read(Position). % TODO: Check if Position is valid
get_move(cc, BoardSize, Cardinal, Position):-
	cardinal_moves(AllCardinal),
	random_member(Cardinal, AllCardinal),
	BoardSize1 is BoardSize + 1,
	random(1, BoardSize1, Position).
