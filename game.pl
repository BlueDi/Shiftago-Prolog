:- use_module(library(lists)).

winner([Line|OtherLines], Winner):-
	(winner_lines([Line|OtherLines], Winner), Winner \= e);
	(winner_column([Line|OtherLines], Winner), Winner \= e);
	(winner_diagonal([Line|OtherLines], Winner), Winner \= e);
	Winner = 'none'.

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

winner_column([Line|OtherLines], Winner):-
	nth1(N, Line, Winner),
	Winner \= e,
	winner_column(N, OtherLines, Winner).
winner_column(_, [], _).
winner_column(N, [Line|OtherLines], Winner):-
	nth1(N, Line, Winner),
	winner_column(N, OtherLines, Winner).

winner_diagonal([Line|OtherLines], Winner):-
	nth1(N, Line, Winner),
	Winner \= e,
	Nplus is N + 1,
	Nminus is N - 1,
	(winner_diagonal_plus(Nplus, OtherLines, Winner); winner_diagonal_minus(Nminus, OtherLines, Winner)).

winner_diagonal_plus(_, [], _).
winner_diagonal_plus(N, [Line|OtherLines], Winner):-
	nth1(N, Line, Winner),
	Nplus is N + 1,
	winner_diagonal_plus(Nplus, OtherLines, Winner).

winner_diagonal_minus(_, [], _).
winner_diagonal_minus(N, [Line|OtherLines], Winner):-
	nth1(N, Line, Winner),
	Nminus is N - 1,
	winner_diagonal_minus(Nminus, OtherLines, Winner).
