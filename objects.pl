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

/* Big Board */
bigboard([
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e, e, e, e, e, e, e, e]
]).

/* Valid Moves */
cardinal_moves([top, left, right, bottom]).

/* Symbols */
translate(e, 'O').
translate(x, 'X').
translate(p1, '1').
translate(p2, '2').
translate(p3, '3').
translate(p4, '4').
