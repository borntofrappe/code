const { Illustration, Anchor, Shape, Ellipse, Rect } = Zdog;

const element = document.querySelector('canvas');
const { width, height } = element;

let turn = 'o';
const dimensions = 3;
const size = width / dimensions;
const scale = 0.7;

const grid = Array(dimensions)
  .fill()
  .map((d, i) =>
    Array(dimensions)
      .fill()
      .map((d, j) => ({
        value: '',
        shape: null,
      }))
  );

const color = 'hsl(220, 90%, 40%)';
const stroke = 25;

const colors = {
  o: 'hsl(155, 80%, 45%)',
  x: 'hsl(45, 100%, 65%)',
};

const illustration = new Illustration({
  element,
  scale
});

const anchorGrid = new Anchor({
  addTo: illustration,
  translate: { x: -width / 2, y: -height / 2, z: 0 },
});

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

let isGameOver = false;
let isCleared = false;
let isAnimating = false;
let animationFrameID = null;
let direction = {
  x: 1,
  y: 1,
  z: 1,
};

function animateClear() {
  animationFrameID = requestAnimationFrame(animateClear);
  illustration.updateRenderGraph();
  illustration.rotate.x += 0.02 * direction.x;
  illustration.rotate.y += 0.02 * direction.y;
  illustration.rotate.z += 0.02 * direction.z;
  if (Math.abs(illustration.rotate.x) > Math.PI) {
    cancelAnimationFrame(animationFrameID);
    illustration.rotate.x = 0;
    illustration.rotate.y = 0;
    illustration.rotate.z = 0;
    illustration.updateRenderGraph();
    isAnimating = false;
  } else if (!isCleared && Math.abs(illustration.rotate.x) > Math.PI / 2) {
    for (const row of grid) {
      for (const cell of row) {
        if (cell.value && cell.shape) {
          cell.value = '';
          cell.shape.remove();
        }
      }
    }
    isCleared = true;
    isGameOver = false;
  }
}

function clear() {
  direction.x =  Math.random() > 0.5 ? 1 : -1;
  direction.y = Math.random() > 0.5 ? 1 : -1;
  direction.z =  Math.random() > 0.5 ? 1 : -1;
  isAnimating = true;
  animateClear();
}

function checkVictory() {
  const indexes = [];
  for (let i = 0; i < dimensions; i += 1) {
    if (
      grid[0][i].value !== '' &&
      grid[0][i].value === grid[1][i].value &&
      grid[1][i].value === grid[2][i].value
    ) {
      indexes.push([0, i], [1, i], [2, i]);
      break;
    }
    if (
      grid[i][0].value !== '' &&
      grid[i][0].value === grid[i][1].value &&
      grid[i][1].value === grid[i][2].value
    ) {
      indexes.push([i, 0], [i, 1], [i, 2]);
      break;
    }
  }
  if (
    grid[0][0].value !== '' &&
    grid[0][0].value === grid[1][1].value &&
    grid[1][1].value === grid[2][2].value
  ) {
    indexes.push([0, 0], [1, 1], [2, 2]);
  }
  if (
    grid[2][0].value !== '' &&
    grid[2][0].value === grid[1][1].value &&
    grid[1][1].value === grid[0][2].value
  ) {
    indexes.push([2, 0], [1, 1], [0, 2]);
  }
  return indexes.length > 0 ? indexes : false;
}

function getTranslucentColor(color) {
  const [h, s, l] = color.match(/\d+/g);
  return `hsla(${h}, ${s}%, ${l}%, 0.3)`;
}

element.addEventListener('click', e => {
  if(!isAnimating) {
    if (isGameOver) {
      clear();
    } else {
      isCleared = false;
  
      const { offsetX, offsetY } = e;
      const paddingX = width * (1 - scale) / 2;
      const paddingY = height * (1 - scale) / 2;
      const widthGrid = width - paddingX * 2;
      const heightGrid = height - paddingY * 2;
  
      if (!(offsetX < paddingX || offsetY < paddingY || offsetX > paddingX + widthGrid || offsetY > paddingY + heightGrid)) {
        const column = Math.floor(((offsetX - paddingX) / widthGrid) * dimensions);
        const row = Math.floor(((offsetY - paddingY) / heightGrid) * dimensions);
        if (grid[row][column].value === '') {
          const x = column * size;
          const y = row * size;
    
          const anchorCell = new Anchor({
            addTo: anchorGrid,
            translate: { x: x + size / 2, y: y + size / 2 },
          });
    
          if (turn === 'o') {
            new Ellipse({
              addTo: anchorCell,
              diameter: size / 2.3,
              stroke: stroke - 5,
              color: colors[turn],
            });
          } else if (turn === 'x') {
            new Shape({
              addTo: anchorCell,
              stroke: stroke - 5,
              color: colors[turn],
              path: [{ x: -size / 5, y: -size / 5 }, { x: size / 5, y: size / 5 }],
            });
            new Shape({
              addTo: anchorCell,
              stroke: stroke - 5,
              color: colors[turn],
              path: [{ x: size / 5, y: -size / 5 }, { x: -size / 5, y: size / 5 }],
            });
          }
    
          grid[row][column].value = turn;
          grid[row][column].shape = anchorCell;
    
          const victoryIndexes = checkVictory();
          if (victoryIndexes) {
            const color = getTranslucentColor(colors[turn]);
            for (const [row, column] of victoryIndexes) {
              new Rect({
                addTo: grid[row][column].shape,
                width: size - stroke - 10,
                height: size - stroke - 10,
                stroke: 0,
                color,
                fill: true,
              });
            }
            isGameOver = true;
          } else {
            const isDraw = grid
              .reduce((acc, curr) => [...acc, ...curr], [])
              .every(({ value }) => value !== '');
    
            if (isDraw) {
              isGameOver = true;
            }
          }
    
          turn = turn === 'o' ? 'x' : 'o';
          illustration.updateRenderGraph();
        }
      }
    }
  }
});
