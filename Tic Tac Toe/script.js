const { Illustration, Anchor, Shape, Ellipse, Rect } = Zdog;

const element = document.querySelector('canvas');
const { width, height } = element;
let turn = 'o';
const dimensions = 3;
const size = width / dimensions;

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

const illustration = new Illustration({
  element,
  scale: 0.95,
});

const anchorGrid = new Anchor({
  addTo: illustration,
  translate: { x: -width / 2, y: -height / 2, z: 0 },
});

for (let dimension = 0; dimension <= dimensions; dimension += 1) {
  const color = 'hsl(220, 90%, 40%)';
  const stroke = 20;

  new Shape({
    addTo: anchorGrid,
    path: [
      { x: (dimension * width) / dimensions, y: 0 },
      { x: (dimension * width) / dimensions, y: height },
    ],
    stroke,
    color
  });

  new Shape({
    addTo: anchorGrid,
    path: [
      { x: 0, y: (dimension * height) / dimensions },
      { x: width, y: (dimension * height) / dimensions },
    ],
    stroke,
    color
  });
}

illustration.updateRenderGraph();

element.addEventListener('click', e => {
  const { offsetX, offsetY } = e;
  const column = Math.floor((offsetX / width) * dimensions);
  const row = Math.floor((offsetY / height) * dimensions);
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
        diameter: size / 2,
        stroke: 20,
        color: 'hsl(155, 80%, 45%)',
      });
    } else if (turn === 'x') {
      // new Rect({
      //   addTo: anchorCell,
      //   width: size - 20,
      //   height: size - 20,
      //   stroke: 0,
      //   color: 'hsla(209, 64%, 53%, 0.2)',
      //   fill: true,
      // });

      new Shape({
        addTo: anchorCell,
        stroke: 20,
        color: 'hsl(45, 100%, 65%)',
        path: [{ x: -size / 4, y: -size / 4 }, { x: size / 4, y: size / 4 }],
      });
      new Shape({
        addTo: anchorCell,
        stroke: 20,
        color: 'hsl(45, 100%, 65%)',
        path: [{ x: size / 4, y: -size / 4 }, { x: -size / 4, y: size / 4 }],
      });
    }

    grid[row][column].value = turn;
    grid[row][column].shape = anchorCell;

    turn = turn === 'o' ? 'x' : 'o';
    illustration.updateRenderGraph();
  }
});

/* good luck
  color: hsl(215, 70%, 13%);
  color: hsl(220, 100%, 60%);
  color: hsl(155, 90%, 45%);
*/