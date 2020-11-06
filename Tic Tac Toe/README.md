# Tic Tac Toe

Here you find two projects:

- `Zdog`, a two-human-players tic tac toe board. The demo works as an introduction to the tic tac toe gameplay, and visualizes the choices through the pseudo-3D engine [Zdog](https://zzz.dog)

- `Minimax`, a tic tac toe board to play against a computer using the [_minimax algorithm_](https://en.wikipedia.org/wiki/Minimax)

The project folder takes inspiration from [a challenge](https://thecodingtrain.com/CodingChallenges/154-tic-tac-toe-minimax.html) from [the coding train](https://thecodingtrain.com/), specifically introducing the algorithm.

## Zdog

This is important: **every time** you add a shape with the zdog library, call `illustration.updateRenderGraph()`. The instruction is necessary to have the engine update the illustration with the new shapes.

Past this reminder, and following the documentations of the engine, the script sets up an illustration and different anchor points. These anchors allow to:

- position the shapes from the top left corner of the canvas element

  ```js
  const anchorGrid = new Anchor({
    addTo: illustration,
    translate: { x: -width / 2, y: -height / 2, z: 0 },
  });
  ```

- attach multiple shapes to the same reference

  ```js
  const anchorCell = new Anchor({
    addTo: anchorGrid,
    translate: { x: x + cellSize / 2, y: y + cellSize / 2 },
  });
  ```

  This anchor is essential to connect the two lines making up the `x` sign, but also useful to consider the rectangles added for the winning combination.

  In the moment you want to clear the board, it's enough to remove the anchors to hide all the connected visuals.

## Minimax

The minimax algorithm is implemented following the instructions of [the coding challenge introduced earlier](https://thecodingtrain.com/CodingChallenges/154-tic-tac-toe-minimax.html).

There is however an important tweak to how the `minimax` function evaluates the score of the two sides. When mapping the score to `1` or `-1`, the risk is having the game pick a winning strategies that takes longer instead of one that takes less. This is evident for instance in the following sequence, where `x` describes the player and `o` the computer:

- the player selects the top left corner

  ```text
  |x| | |
  | | | |
  | | | |
  ```

- the computer picks the cell in the center

  ```text
  |x| | |
  | |o| |
  | | | |
  ```

- the player selects the top right corner

  ```text
  |x| |x|
  | |o| |
  | | | |
  ```

- the computer prevents a match selecting the top cell

  ```text
  |x|o|x|
  | |o| |
  | | | |
  ```

- the player selects the bottom right corner, leaving a spot open for a match

  ```text
  |x|o|x|
  | |o| |
  | | |x|
  ```

In this situation, the computer **does not** pick the cell in the bottom center. Instead, it prevents a match selecting the spot on the right.

```text
|x|o|x|
| |o|o|
| | |x|
```

The algorithm works, as the computer inevitably wins in the turn which follows, but personally, I'd have the game terminate earlier. To implement this feature, the idea is to weigh the score with the `depth` value.

```diff
if (winner) {
-  return scores[winner];
+  return scores[winner] / depth;
}
```

With this change, a victory in the turns which follows, `1 / 0`, scores higher than a victory three turns ahead, `1 / 3`.

_Please note_: `depth` is first initialized with a value of `0`. While dividing by `0` works, I decided to finally increment the depth to consider values in the `(0, 1]` range.

```js
return scores[winner] / (depth + 1);
```

This is a matter of personal preference, considering how the result of a division by `0` might be less than immediate. For context, and in terms of JavaScript, `1` divided by `0` returns `Infinity`.
