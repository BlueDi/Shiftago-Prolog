/* Board */
board([
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e],
	[e, e, e, e, e, e, e]
]).

miniboard([
	[e, e, e],
	[e, e, e],
	[e, e, e]
]).
	
/* Symbols */
translate(e, 'O').
translate(x, 'X').
translate(p1, '1').
translate(p2, '2').

/* Move inputs */
move_input(l1, left, 1).
move_input(l2, left, 2).
move_input(l3, left, 3).
move_input(l4, left, 4).
move_input(l5, left, 5).
move_input(l6, left, 6).
move_input(l7, left, 7).
move_input(r1, right, 1).
move_input(r2, right, 2).
move_input(r3, right, 3).
move_input(r4, right, 4).
move_input(r5, right, 5).
move_input(r6, right, 6).
move_input(r7, right, 7).
move_input(t1, top, 1).
move_input(t2, top, 2).
move_input(t3, top, 3).
move_input(t4, top, 4).
move_input(t5, top, 5).
move_input(t6, top, 6).
move_input(t7, top, 7).
move_input(b1, bottom, 1).
move_input(b2, bottom, 2).
move_input(b3, bottom, 3).
move_input(b4, bottom, 4).
move_input(b5, bottom, 5).
move_input(b6, bottom, 6).
move_input(b7, bottom, 7).

/* Switch Player */
switch_player(Player, NewPlayer):-
	(NewPlayer = 'p2', Player \= 'p2');
	NewPlayer = 'p1'.