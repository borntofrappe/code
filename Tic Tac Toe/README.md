# Tic Tac Toe

The goal of this project is two-fold:

- create a game of tic-tac-toe for two human players

- implement the _minimax algorithm_ to have the game occur between a human player and computer AI

The demo takes inspiration from [a challenge](https://thecodingtrain.com/CodingChallenges/149-tic-tac-toe.html) from [the coding train](https://thecodingtrain.com/), and uses the `<canvas>` element in conjunction with the [`Zdog`](https://zzz.dog) pseudo-3D engine.

## Zdog

The first experiment introduces a lot of concepts connected to the Zdog library, but allows to practice with several features of the JavaScript language as well. Consider the use of `for of` loops, or again `array.reduce` to spread the contents of a 2D array into a one-dimensional data structure, or again `string.match()` to extract the `hsl` components from the current color.

The idea is to provide a frame with a series of lines, and plot two types of shapes, an ellipse and two crossing lines to symbolize the `o` and `x` of a tic-tac-toe board.

## Minimax

Building on the progress achieved with _Tic Tac Zdog_, the second experiment allows for user input, but every other move is managed by the computer. The goal is to implement the minimax algorithm so that immediately, as the player selects an available cell, the script intervenes to:

- check for a victory

- check for a tie

- provide the next move

_Update_: document how the best move is picked regardless of how fast it is achieved. This can be fixed considering the depth.
