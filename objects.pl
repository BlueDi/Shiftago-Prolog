/* Board */
board([
	[x, x, x, e, e, e, e],
	[e, e, x, e, e, e, e],
	[e, e, x, e, e, e, e],
	[e, e, x, e, e, e, e],
	[e, e, x, x, x, x, e],
	[e, e, e, e, e, x, e],
	[e, e, e, e, e, x, e]
]).

miniboard([
	[p1, p2, p1],
	[p2, e, e],
	[e, e, e]
]).
	
/* Symbols */
translate(e, 'O').
translate(x, 'X').
translate(p1, '1').
translate(p2, '2').
