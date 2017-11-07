/* Main Board */
board([
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e]
]).

/* Mini Board for tests */
miniboard([
	[e, e, e],
	[e, e, e],
	[e, e, e]
]).

/* Valid Moves */
cardinal_moves([top, left, right, bottom]).

/* Symbols */
translate(e, 'O').
translate(x, 'X').
translate(p1, '1').
translate(p2, '2').

/* Switch Player */
switch_player(Player, NewPlayer):-
	(NewPlayer = 'p2', Player \= 'p2');
	NewPlayer = 'p1'.
