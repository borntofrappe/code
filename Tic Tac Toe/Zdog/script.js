// SETUP
const { Illustration, Anchor, Shape, Ellipse, Rect } = Zdog;

const canvas = document.querySelector('canvas');
const { width, height } = canvas;

let currentTurn = 'o';
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

// CLICK INTERACTION
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
          // add current turn
          addToGrid(currentTurn, row, column);
          // terminate the game for a victory, highlighting the winner
          const { winner, position } = checkWinner();
          if (winner) {
            highlightWinner(winner, position);
            isGameOver = true;
          }
          // terminate the game for a tie
          if (checkTie()) {
            isGameOver = true;
          }
          // alternate the current turn
          currentTurn = currentTurn === 'o' ? 'x' : 'o';
          illustration.updateRenderGraph();
        }
      }
    }
  }
});
