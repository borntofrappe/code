// SETUP
const { Illustration, Anchor, Shape, Ellipse, Rect } = Zdog;

const canvas = document.querySelector('canvas');
const { width, height } = canvas;

const dimensions = 3;
/* tic tac toe board
[
  ["", "", ""],
  ["", "", ""],
  ["", "", ""]
]
*/
const grid = Array(dimensions)
  .fill()
  .map(() =>
    Array(dimensions)
      .fill()
      .map(() => ({
        value: '',
        visual: null,
      }))
  );

// scale the illustration down to avoid cropping as the shapes are rotated on the x-y-z axes
const gridScale = 0.7;
const gridColor = 'hsl(220, 90%, 40%)';
const gridStroke = 25;
const cellSize = width / dimensions;

const turnsColor = {
  o: 'hsl(155, 80%, 45%)',
  x: 'hsl(45, 100%, 65%)',
};
const turnsStroke = 20;

// ZDOG ILLUSTRATION
const illustration = new Illustration({
  element: canvas,
  scale: gridScale,
});

// add an anchor point to include shapes from the top left corner
const anchorGrid = new Anchor({
  addTo: illustration,
  translate: { x: -width / 2, y: -height / 2, z: 0 },
});

// GRID LINES
for (let dimension = 0; dimension <= dimensions; dimension += 1) {
  new Shape({
    addTo: anchorGrid,
    path: [
      { x: (dimension * width) / dimensions, y: 0 },
      { x: (dimension * width) / dimensions, y: height },
    ],
    stroke: gridStroke,
    color: gridColor,
  });

  new Shape({
    addTo: anchorGrid,
    path: [
      { x: 0, y: (dimension * height) / dimensions },
      { x: width, y: (dimension * height) / dimensions },
    ],
    stroke: gridStroke,
    color: gridColor,
  });
}

illustration.updateRenderGraph();

// GAMEPLAY
let isGameOver = false;
let isCleared = false;
let isAnimating = false;

// pick the player at random, the computer the opposing side
let player = Math.random() > 0.5 ? 'o' : 'x';
let computer = player === 'o' ? 'x' : 'o';

let scores = {
  [player]: -1,
  [computer]: 1,
  tie: 0,
};

// CLEAR GRID
// use requestAnimationFrame to rotate the grid around its center
let animationFrameID = null;
const directionRotation = {
  x: 1,
  y: 1,
  z: 1,
};

function animateClear() {
  animationFrameID = requestAnimationFrame(animateClear);
  illustration.updateRenderGraph();
  illustration.rotate.x += 0.02 * directionRotation.x;
  illustration.rotate.y += 0.02 * directionRotation.y;
  illustration.rotate.z += 0.02 * directionRotation.z;
  if (Math.abs(illustration.rotate.x) > Math.PI) {
    cancelAnimationFrame(animationFrameID);
    illustration.rotate.x = 0;
    illustration.rotate.y = 0;
    illustration.rotate.z = 0;
    illustration.updateRenderGraph();
    isAnimating = false;
    isGameOver = false;

    // reinitialize player, computer and connected score values
    player = Math.random() > 0.5 ? 'o' : 'x';
    computer = player === 'o' ? 'x' : 'o';
    scores = {
      [player]: -1,
      [computer]: 1,
      tie: 0,
    };
  } else if (!isCleared && Math.abs(illustration.rotate.x) > Math.PI / 2) {
    for (const row of grid) {
      for (const cell of row) {
        if (cell.value && cell.visual) {
          cell.value = '';
          cell.visual.remove();
        }
      }
    }
    isCleared = true;
  }
}

function clear() {
  directionRotation.x = Math.random() > 0.5 ? 1 : -1;
  directionRotation.y = Math.random() > 0.5 ? 1 : -1;
  directionRotation.z = Math.random() > 0.5 ? 1 : -1;
  isCleared = false;
  isAnimating = true;
  animateClear();
}

// UTILITY FUNCTIONS
// check winner returning the winning side and an array describing the winning combination
function checkWinner() {
  let winner = null;
  const position = [];
  for (let i = 0; i < dimensions; i += 1) {
    if (
      grid[0][i].value !== '' &&
      grid[0][i].value === grid[1][i].value &&
      grid[1][i].value === grid[2][i].value
    ) {
      winner = grid[0][i].value;
      position.push([0, i], [1, i], [2, i]);
      break;
    }
    if (
      grid[i][0].value !== '' &&
      grid[i][0].value === grid[i][1].value &&
      grid[i][1].value === grid[i][2].value
    ) {
      winner = grid[i][0].value;
      position.push([i, 0], [i, 1], [i, 2]);
      break;
    }
  }
  if (
    grid[0][0].value !== '' &&
    grid[0][0].value === grid[1][1].value &&
    grid[1][1].value === grid[2][2].value
  ) {
    winner = grid[0][0].value;
    position.push([0, 0], [1, 1], [2, 2]);
  }
  if (
    grid[2][0].value !== '' &&
    grid[2][0].value === grid[1][1].value &&
    grid[1][1].value === grid[0][2].value
  ) {
    winner = grid[2][0].value;
    position.push([2, 0], [1, 1], [0, 2]);
  }

  return { winner, position };
}

// check tie considering available cells
function checkTie() {
  return grid
    .reduce((acc, curr) => [...acc, ...curr], [])
    .every(({ value }) => value !== '');
}

// add a specific turn to the grid, and to the zdog illustration
function addToGrid(turn, row, column) {
  if (grid[row][column].value === '') {
    // visual
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
        stroke: turnsStroke,
        color: turnsColor[turn],
      });
    } else if (turn === 'x') {
      new Shape({
        addTo: anchorCell,
        stroke: turnsStroke,
        color: turnsColor[turn],
        path: [
          { x: -cellSize / 5, y: -cellSize / 5 },
          { x: cellSize / 5, y: cellSize / 5 },
        ],
      });
      new Shape({
        addTo: anchorCell,
        stroke: turnsStroke,
        color: turnsColor[turn],
        path: [
          { x: cellSize / 5, y: -cellSize / 5 },
          { x: -cellSize / 5, y: cellSize / 5 },
        ],
      });
    }

    // include the visual to later remove the graphic from the illustration
    grid[row][column].value = turn;
    grid[row][column].visual = anchorCell;
  }
}

// return a semi-transparent version of the input color
function getTranslucentHSL(hsl) {
  const [h, s, l] = hsl.match(/\d+/g);
  return `hsla(${h}, ${s}%, ${l}%, 0.3)`;
}

// highlight the winning side including rectangles in the cells describing the winning combination
function highlightWinner(winner, position) {
  const color = getTranslucentHSL(turnsColor[winner]);
  for (const [row, column] of position) {
    new Rect({
      addTo: grid[row][column].visual,
      width: cellSize - gridStroke - 10,
      height: cellSize - gridStroke - 10,
      stroke: 0,
      color,
      fill: true,
    });
  }
}

// COMPUTER AI
// pick a cell at random from the available set
function randomMove() {
  const positions = [];
  for (let row = 0; row < dimensions; row += 1) {
    for (let column = 0; column < dimensions; column += 1) {
      if (grid[row][column].value === '') {
        positions.push([row, column]);
      }
    }
  }

  return positions[Math.floor(Math.random() * positions.length)];
}

// compute the score with the minimax algorithm
function minimax(board, depth, isMaximising) {
  const { winner } = checkWinner();
  if (winner) {
    // ! use the depth to weigh the score
    // the idea is to attribute a higher score to victories achieved early
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

// pick the cell describing the best move
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
// have the computer play immediately after the player
canvas.addEventListener('click', e => {
  // prevent any action if the grid is being animated
  if (!isAnimating) {
    if (isGameOver) {
      // clear the grid if the game reached a conclusion
      clear();
    } else {
      // ! consider the fact that the grid is scaled down
      const { offsetX, offsetY } = e;
      const paddingX = (width * (1 - gridScale)) / 2;
      const paddingY = (height * (1 - gridScale)) / 2;
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
          // add player turn
          addToGrid(player, row, column);
          // terminate the game for a victory, highlighting the winner
          const { winner, position } = checkWinner();
          if (winner) {
            highlightWinner(winner, position);
            isGameOver = true;
          } else if (checkTie()) {
            // terminate the game for a tie
            isGameOver = true;
          } else {
            // computer turn
            // const [rowComputer, columnComputer] = randomMove(); // pick at random
            const [rowComputer, columnComputer] = bestMove(); // pick through the minimax algorithm
            addToGrid(computer, rowComputer, columnComputer);
            // repeat the same checkup for the victory/tie on the computer side
            const {
              winner: winnerComputer,
              position: indexesComputer,
            } = checkWinner();
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
