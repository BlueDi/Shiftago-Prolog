:- include('objects.pl').
:- include('board.pl').
:- include('game.pl').

shiftago(Empty):-
	write('Please pick a board to play: normal, or mini\n'),
	read(BoardName),
	((BoardName = 'normal', board(Board)); (BoardName = 'mini', miniboard(Board))),
	play(Board).

play(Board):-
	place_piece(Board, p1, left, 2, Board2),
	place_piece(Board2, p2, right, 2, Board3),
	place_piece(Board3, p1, right, 6, Board4),
	place_piece(Board4, p2, right, 2, Board5),
	place_piece(Board5, p2, top, 2, Board6),
	place_piece(Board6, p2, bottom, 5, Board7),
	place_piece(Board7, p2, bottom, 5, Board8),
	place_piece(Board8, p2, left, 5, Board9),
	place_piece(Board9, p2, left, 5, Board10),
	place_piece(Board10, p2, left, 5, Board11),
	place_piece(Board11, p2, left, 5, Board12),
	place_piece(Board12, p2, bottom, 5, Board13),
	place_piece(Board13, p1, bottom, 5, Board14),
	display_board(Board14).
