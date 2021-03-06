const canvas = document.querySelector('canvas');

let { innerHeight: height, innerWidth: width } = window;
canvas.width = width;
canvas.height = height;

const context = canvas.getContext('2d');

const spacing = 15;
const odds = () => Math.random() > 0.5;

function resize() {
  width = window.innerWidth;
  height = window.innerHeight;
  canvas.width = width;
  canvas.height = height;
}

function draw() {
  context.clearRect(0, 0, width, height);
  for (let x = 0; x < width; x += spacing) {
    for (let y = 0; y < height; y += spacing) {
      context.beginPath();
      if (odds()) {
        context.moveTo(x, y);
        context.lineTo(x + spacing, y + spacing);
      } else {
        context.moveTo(x + spacing, y);
        context.lineTo(x, y + spacing);
      }
      context.closePath();
      context.stroke();
    }
  }
}

draw();

window.addEventListener('resize', () => {
  resize();
  draw();
});
window.addEventListener('click', () => draw());
