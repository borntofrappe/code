document.body.style.margin = 0;
document.body.style.overflow = 'hidden';
document.body.style.backgroundColor = 'rgb(0, 0, 0)';
const { innerWidth, innerHeight } = window;

document.body.innerHTML = `<canvas width="${innerWidth}" height="${innerHeight}"></canvas>`;

const canvas = document.querySelector('canvas');
const { width: WINDOW_WIDTH, height: WINDOW_HEIGHT } = canvas;
const context = canvas.getContext('2d');

const ODDS_FIREWORK = 70;
const ODDS_FIREWORK_HEART = 5;
const GRAVITY = 0.03;
const VELOCITY_MIN = 3;
const VELOCITY_MAX = 6;

const PARTICLE_VELOCITY = 2;
const PARTICLE_GRAVITY = 0.005;

let fireworks = [];

function animate() {
  context.clearRect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  if(Math.floor(Math.random() * ODDS_FIREWORK) === 1) {
    if(Math.floor(Math.random() * ODDS_FIREWORK_HEART) === 1) {
    fireworks.push(new HeartFirework())
    }
    else {
    fireworks.push(new Firework())
    }
  }

  for(const firework of fireworks) {
    firework.update();
    firework.show(context);
  }

  for(i = fireworks.length-1; i >= 0; i -= 1) {
    if (fireworks[i].hasExpired) {
      fireworks = [...fireworks.slice(0, i), ... fireworks.slice(i + 1)];
    }
  }

  requestAnimationFrame(animate);
}
animate();