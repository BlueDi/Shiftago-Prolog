# Shiftago

Shiftago is a game in which the goal is to make a horizontal, vertical, or diagonal line along the board. It is only possible to add pieces to the board by its edges, and it is not possible to add pieces to already full lines. In the original game, it is possible to have up to 4 players in a match, but __only the first player is human__ in _Human vs. Computer_ mode.

![Intermediate Board](https://user-images.githubusercontent.com/9451036/53270227-0de37f80-36e3-11e9-840f-62be7d6d2a93.png)

Site do jogo original: http://www.shiftago.com/en/rules.htm

## Instructions
To run the game is used the predicate `shiftago(-Winner)`. This predicate starts the game and prompts the user to _input_ the game.

The setting process begins with the choice of the desired tray. There are 3 trays available: _normal_, _big_, and _small_, being _normal_ the transformation of the original game, and the other _2_ to show the scalability of the game.

Then the user will be asked to choose the game mode, _CPU vs. CPU_, _Human vs. CPU_, and _Human vs. Human_, where CPU represents the computer, and _input_ is done by the abbreviations `cc`, `hc`, and `hh`, respectively.

Then the number of players is requested, which can be 2, 3, or 4. Regardless of the number of players only the _Human vs. Human_ mode allows playing 2 or more humans in a match.

If you have chosen a mode with Computer, you will now be asked to choose the _hard_ or _easy_ difficulty level for the Computer, thus ending the game details.

With the setup of the game set, the game starts. Each change of player is shown the board, and if it is the turn of a human player is also shown a list with all possible moves and is asked input on where to place the piece. If the input is not valid, you are prompted to re-enter new input. It is written on the screen the player's play and the current winner, by default `none`. When it is found a match winner is written `GAME OVER`, the _final board_, and returned the _winner_.
