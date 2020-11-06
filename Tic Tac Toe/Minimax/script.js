// SETUP
const { Illustration, Anchor, Shape, Ellipse, Rect } = Zdog;
const element = document.querySelector('canvas');
const { width, height } = element;

/* tic tac toe board
[
  ["", "", ""],
  ["", "", ""],
  ["", "", ""]
]
*/
const dimensions = 3;
const grid = Array(dimensions)
  .fill()
  .map(() =>
    Array(dimensions)
      .fill()
      .map(() => ({
        value: '',
        shape: null,
      }))
  );

// scale back the illustration to consider the rotation on three axes
const scale = 0.7;

const color = 'hsl(220, 90%, 40%)';
const stroke = 25;

// DEFAULT VISUALS
// illustration
const illustration = new Illustration({
  element,
  scale,
});

// anchor point moving the shapes to the top left corner
const anchorGrid = new Anchor({
  addTo: illustration,
  translate: { x: -width / 2, y: -height / 2, z: 0 },
});

// lines framing the grid
for (let dimension = 0; dimension <= dimensions; dimension += 1) {
  new Shape({
    addTo: anchorGrid,
    path: [
      { x: (dimension * width) / dimensions, y: 0 },
      { x: (dimension * width) / dimensions, y: height },
    ],
    stroke,
    color,
  });

  new Shape({
    addTo: anchorGrid,
    path: [
      { x: 0, y: (dimension * height) / dimensions },
      { x: width, y: (dimension * height) / dimensions },
    ],
    stroke,
    color,
  });
}

illustration.updateRenderGraph();

// PLAYER INTERACTION
/* controlling variables to
- avoid interaction as requestAnimationFrame animates the grid
- avoid calling shape.remove() repeatedly
- clear the board following a gameover
*/
let isAnimating = false;
let isCleared = false;
let isGameOver = false;
let animationFrameID = null;

// pick the player at random, the computer the opposing side
let player = Math.random() > 0.5 ? 'o' : 'x';
let computer = player === 'o' ? 'x' : 'o';

let scores = {
  [player]: -1,
  [computer]: 1,
  tie: 0,
};

const colors = {
  o: 'hsl(155, 80%, 45%)',
  x: 'hsl(45, 100%, 65%)',
};
const cellSize = width / dimensions;

// the idea is to rotate the grid on the x,y,z axes incrementing/decrementing the matching rotation
const directionRotation = {
  x: 1,
  y: 1,
  z: 1,
};

// function rotating the grid and removing existing shapes
// ! call updateRenderGraph() to have the shapes match the final rotation
function animateClear() {
  animationFrameID = requestAnimationFrame(animateClear);
  illustration.rotate.x += 0.02 * directionRotation.x;
  illustration.rotate.y += 0.02 * directionRotation.y;
  illustration.rotate.z += 0.02 * directionRotation.z;
  illustration.updateRenderGraph();
  // remove animation after a full rotation
  if (Math.abs(illustration.rotate.x) > Math.PI) {
    cancelAnimationFrame(animationFrameID);
    illustration.rotate.x = 0;
    illustration.rotate.y = 0;
    illustration.rotate.z = 0;
    illustration.updateRenderGraph();

    // reset initial values
    isAnimating = false;
    isGameOver = false;
    // reinitialize player and computer
    player = Math.random() > 0.5 ? 'o' : 'x';
    computer = player === 'o' ? 'x' : 'o';
    scores = {
      [player]: -1,
      [computer]: 1,
      tie: 0,
    };
  } else if (!isCleared && Math.abs(illustration.rotate.x) > Math.PI / 2) {
    // remove the shapes after half a rotation
    for (const row of grid) {
      for (const cell of row) {
        if (cell.value && cell.shape) {
          cell.value = '';
          cell.shape.remove();
        }
      }
    }
    isCleared = true;
  }
}

// clear the board by calling the function managing requestAnimationFrame
function clear() {
  // update the direction of the rotation for the available axes
  directionRotation.x = Math.random() > 0.5 ? 1 : -1;
  directionRotation.y = Math.random() > 0.5 ? 1 : -1;
  directionRotation.z = Math.random() > 0.5 ? 1 : -1;
  isAnimating = true;
  animateClear();
}

// return the winning side and the winning indexes
function checkWinner() {
  let winner = null;
  const indexes = [];
  for (let i = 0; i < dimensions; i += 1) {
    if (
      grid[0][i].value !== '' &&
      grid[0][i].value === grid[1][i].value &&
      grid[1][i].value === grid[2][i].value
    ) {
      winner = grid[0][i].value;
      indexes.push([0, i], [1, i], [2, i]);
      break;
    }
    if (
      grid[i][0].value !== '' &&
      grid[i][0].value === grid[i][1].value &&
      grid[i][1].value === grid[i][2].value
    ) {
      winner = grid[i][0].value;
      indexes.push([i, 0], [i, 1], [i, 2]);
      break;
    }
  }
  if (
    grid[0][0].value !== '' &&
    grid[0][0].value === grid[1][1].value &&
    grid[1][1].value === grid[2][2].value
  ) {
    winner = grid[0][0].value;
    indexes.push([0, 0], [1, 1], [2, 2]);
  }
  if (
    grid[2][0].value !== '' &&
    grid[2][0].value === grid[1][1].value &&
    grid[1][1].value === grid[0][2].value
  ) {
    winner = grid[2][0].value;
    indexes.push([2, 0], [1, 1], [0, 2]);
  }

  return { winner, indexes };
}

// return true if there are no available cells
function checkTie() {
  return grid
    .reduce((acc, curr) => [...acc, ...curr], [])
    .every(({ value }) => value !== '');
}

// add an 'x' or 'o' to the grid
function addToGrid(row, column, turn) {
  if (grid[row][column].value === '') {
    // Zdog illustration
    const x = column * cellSize;
    const y = row * cellSize;

    const anchorCell = new Anchor({
      addTo: anchorGrid,
      translate: { x: x + cellSize / 2, y: y + cellSize / 2 },
    });

    if (turn === 'o') {
      new Ellipse({
        addTo: anchorCell,
        diameter: cellSize / 2.3,
        stroke: stroke - 5,
        color: colors[turn],
      });
    } else if (turn === 'x') {
      new Shape({
        addTo: anchorCell,
        stroke: stroke - 5,
        color: colors[turn],
        path: [
          { x: -cellSize / 5, y: -cellSize / 5 },
          { x: cellSize / 5, y: cellSize / 5 },
        ],
      });
      new Shape({
        addTo: anchorCell,
        stroke: stroke - 5,
        color: colors[turn],
        path: [
          { x: cellSize / 5, y: -cellSize / 5 },
          { x: -cellSize / 5, y: cellSize / 5 },
        ],
      });
    }

    // data structure
    // storing a reference to the achor is necessary to later remove the shapes from the illustration
    grid[row][column].value = turn;
    grid[row][column].shape = anchorCell;
  }
}

/* check a gameover and return
- player or computer if either side won
- 'tie' if there are no more cells available
- null otherwise 
*/

// return a semitransparent version of the input hsl color
function getTransluentHSL(hsl) {
  const [h, s, l] = hsl.match(/\d+/g);
  return `hsla(${h}, ${s}%, ${l}%, 0.3)`;
}

// highlight the winner with rectangles for the winning combination
function highlightWinner(winner, indexes) {
  const colorWinner = getTransluentHSL(colors[winner]);
  for (const [row, column] of indexes) {
    new Rect({
      addTo: grid[row][column].shape,
      width: cellSize - stroke - 10,
      height: cellSize - stroke - 10,
      stroke: 0,
      color: colorWinner,
      fill: true,
    });
  }
}

// COMPUTER AI
function randomMove() {
  const indexes = [];
  for (let row = 0; row < dimensions; row += 1) {
    for (let column = 0; column < dimensions; column += 1) {
      if (grid[row][column].value === '') {
        indexes.push([row, column]);
      }
    }
  }

  const randomIndex = Math.floor(Math.random() * indexes.length);
  return indexes[randomIndex];
}

function minimax(board, depth, isMaximising) {
  const { winner } = checkWinner();
  if (winner) {
    return scores[winner] / depth;
  }

  if (checkTie()) {
    return scores.tie;
  }

  let bestScore = isMaximising ? -Infinity : Infinity;
  if (isMaximising) {
    for (let row = 0; row < dimensions; row += 1) {
      for (let column = 0; column < dimensions; column += 1) {
        if (board[row][column].value === '') {
          board[row][column].value = computer;
          bestScore = Math.max(bestScore, minimax(board, depth + 1, false));
          board[row][column].value = '';
        }
      }
    }
  } else {
    for (let row = 0; row < dimensions; row += 1) {
      for (let column = 0; column < dimensions; column += 1) {
        if (board[row][column].value === '') {
          board[row][column].value = player;
          bestScore = Math.min(bestScore, minimax(board, depth + 1, true));
          board[row][column].value = '';
        }
      }
    }
  }
  return bestScore;
}

function bestMove() {
  let bestScore = -Infinity;
  let move = [];
  for (let row = 0; row < dimensions; row += 1) {
    for (let column = 0; column < dimensions; column += 1) {
      if (grid[row][column].value === '') {
        grid[row][column].value = computer;
        const score = minimax(grid, 0, false);
        if (score > bestScore) {
          bestScore = score;
          move = [row, column];
        }
        grid[row][column].value = '';
      }
    }
  }

  return move;
}

// CLICK INTERACTION
// consider player and computer in succession
element.addEventListener('click', e => {
  if (!isAnimating) {
    if (isGameOver) {
      clear();
    } else {
      isCleared = false;

      // ! consider the fact that the canvas is scaled back
      const { offsetX, offsetY } = e;
      const paddingX = (width * (1 - scale)) / 2;
      const paddingY = (height * (1 - scale)) / 2;
      const widthGrid = width - paddingX * 2;
      const heightGrid = height - paddingY * 2;

      // check which cell was selected matching the x and y coordinates
      if (
        !(
          offsetX < paddingX ||
          offsetY < paddingY ||
          offsetX > paddingX + widthGrid ||
          offsetY > paddingY + heightGrid
        )
      ) {
        const column = Math.floor(
          ((offsetX - paddingX) / widthGrid) * dimensions
        );
        const row = Math.floor(
          ((offsetY - paddingY) / heightGrid) * dimensions
        );

        if (grid[row][column].value === '') {
          // PLAYER
          addToGrid(row, column, player);
          const { winner, indexes } = checkWinner();
          if (winner) {
            highlightWinner(winner, indexes);
            isGameOver = true;
          } else if (checkTie()) {
            isGameOver = true;
          } else {
            // COMPUTER
            // const [rowComputer, columnComputer] = randomMove(); // pick at random
            const [rowComputer, columnComputer] = bestMove(); // pick through the minimax function
            addToGrid(rowComputer, columnComputer, computer);
            const { winner: winnerComputer, indexes: indexesComputer } = checkWinner();
            if (winnerComputer) {
              highlightWinner(winnerComputer, indexesComputer);
              isGameOver = true;
            } else if (checkTie()) {
              isGameOver = true;
            }
          }
          illustration.updateRenderGraph();
        }
      }
    }
  }
});
