:- use_module(library(lists)).

/* Switch Player */
switch_player(Player, NewPlayer, NPlayers):-
	NewPlayer = 'p4',
	Player == 'p3',
	NPlayers > 3.
switch_player(Player, NewPlayer, NPlayers):-
	NewPlayer = 'p3',
	Player == 'p2',
	NPlayers > 2.
switch_player(Player, NewPlayer, _):-
	NewPlayer = 'p2',
	Player == 'p1'.
switch_player(_, NewPlayer, _):-
	NewPlayer = 'p1'.

/* Winner */
winner([Line|OtherLines], Winner):-
	(winner_lines([Line|OtherLines], Winner), Winner \= e);
	(winner_column([Line|OtherLines], Winner), Winner \= e);
	(winner_diagonal([Line|OtherLines], Winner), Winner \= e);
	Winner = 'none'.

% Winner by line
winner_lines([], _).
winner_lines([Line|OtherLines], Winner):-
	winner_line(Line, Winner);
	winner_lines(OtherLines, Winner).
	
winner_line(Line, Winner):-
	length(Line, ListSize),
	count_elem(Winner, Line, ListSize).
	
count_elem(_, [], 0).
count_elem(X, [Y|Lista], N):-
	X \= Y,
	count_elem(X, Lista, N).
count_elem(X, [X|Lista], N):-
	count_elem(X, Lista, N1),
	N is N1 + 1.

% Winner by column
winner_column([Line|OtherLines], Winner):-
	nth1(N, Line, Winner),
	Winner \= e,
	winner_column(N, OtherLines, Winner).
winner_column(_, [], _).
winner_column(N, [Line|OtherLines], Winner):-
	nth1(N, Line, Winner),
	winner_column(N, OtherLines, Winner).

% Winner by diagonal
winner_diagonal([Line|OtherLines], Winner):-
	nth1(N, Line, Winner),
	Winner \= e,
	Nplus is N + 1,
	Nminus is N - 1,
	(winner_diagonal_plus(Nplus, OtherLines, Winner); winner_diagonal_minus(Nminus, OtherLines, Winner)).

% Winner by diagonal from left to right
winner_diagonal_plus(_, [], _).
winner_diagonal_plus(N, [Line|OtherLines], Winner):-
	nth1(N, Line, Winner),
	Nplus is N + 1,
	winner_diagonal_plus(Nplus, OtherLines, Winner).

% Winner by diagonal from right to left
winner_diagonal_minus(_, [], _).
winner_diagonal_minus(N, [Line|OtherLines], Winner):-
	nth1(N, Line, Winner),
	Nminus is N - 1,
	winner_diagonal_minus(Nminus, OtherLines, Winner).
