document.body.style.margin = 0;
document.body.style.overflow = 'hidden';
document.body.style.backgroundColor = 'rgb(0, 0, 0)';
const { innerWidth, innerHeight } = window;

document.body.innerHTML = `<canvas width="${innerWidth}" height="${innerHeight}"></canvas>`;

const canvas = document.querySelector('canvas');
let { width, height } = canvas;
const context = canvas.getContext('2d');

const HEIGHT_TO_GRAVITY_FIREWORK = 1 / 30000;
const GRAVITY_TO_VELOCITY_FIREWORK = 125;
const HEIGHT_TO_GRAVITY_FRAGMENT = 1 / 180000;
const VELOCITY_TO_THRESHOLD_FIREWORK = 1 / 6;
const GRAVITY_TO_VELOCITY_FRAGMENT = 500;
const VELOCITY_TO_FRAGMENT_HEART = 1 / 40;
const FRAGMENT_HEART_VELOCITY = 1 / 40;
const FRAGMENT_HEART_VELOCITY_CHANGE_MAX = 1 / 3;

const FIREWORK_MAX = 5;
const FIREWORK_ODDS = 1 / 70;
const FIREWORK_HEART_ODDS = 1 / 5;
let fireworkGravity = height * HEIGHT_TO_GRAVITY_FIREWORK;
let fireworkVelocityMin = fireworkGravity * GRAVITY_TO_VELOCITY_FIREWORK;
let fireworkVelocityMax = fireworkVelocityMin * 2;
let fireworkVelocityThreshold =
  fireworkGravity * VELOCITY_TO_THRESHOLD_FIREWORK;
const FIREWORK_RADIUS = 4;
const FIREWORK_RADIUS_DECREASE = 1 / 50;

let fragmentGravity = height * HEIGHT_TO_GRAVITY_FRAGMENT;
let fragmentVelocity = fragmentGravity * GRAVITY_TO_VELOCITY_FRAGMENT;
const FRAGMENT_RADIUS = 3;
const FRAGMENT_RADIUS_DECREASE = 1 / 25;

const degreesToRadians = degrees => (degrees / 180) * Math.PI;
const getColor = () => `hsl(${Math.floor(Math.random() * 360)}, 85%, 70%)`;

let fireworks = [];

function animate() {
  context.clearRect(0, 0, width, height);
  if (fireworks.length < FIREWORK_MAX && Math.random() > 1 - FIREWORK_ODDS) {
    if (Math.random() > 1 - FIREWORK_HEART_ODDS) {
      fireworks.push(new HeartFirework());
    } else {
      fireworks.push(new Firework());
    }
  }

  for (const firework of fireworks) {
    firework.update();
    firework.show(context);
  }

  for (let i = fireworks.length - 1; i >= 0; i -= 1) {
    if (fireworks[i].hasExpired) {
      fireworks = [...fireworks.slice(0, i), ...fireworks.slice(i + 1)];
    }
  }

  requestAnimationFrame(animate);
}
animate();

window.addEventListener('click', () => {
  if (fireworks.length < FIREWORK_MAX) {
    if (Math.random() > 1 - FIREWORK_HEART_ODDS) {
      fireworks.push(new HeartFirework());
    } else {
      fireworks.push(new Firework());
    }
  }
});

window.addEventListener('resize', function() {
  const { innerWidth, innerHeight } = window;
  if (innerWidth !== width || innerHeight !== height) {
    width = innerWidth;
    height = innerHeight;
    canvas.width = width;
    canvas.height = height;

    fireworkGravity = height * HEIGHT_TO_GRAVITY_FIREWORK;
    fireworkVelocityMin = fireworkGravity * GRAVITY_TO_VELOCITY_FIREWORK;
    fireworkVelocityMax = fireworkVelocityMin * 2;
    fireworkVelocityThreshold =
      fireworkGravity * VELOCITY_TO_THRESHOLD_FIREWORK;

    fragmentGravity = height * HEIGHT_TO_GRAVITY_FRAGMENT;
    fragmentVelocity = fragmentGravity * GRAVITY_TO_VELOCITY_FRAGMENT;
  }
});
