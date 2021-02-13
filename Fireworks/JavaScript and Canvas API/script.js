document.body.style.margin = 0;
document.body.style.overflow = 'hidden';
document.body.style.backgroundColor = 'rgb(0, 0, 0)';
const { innerWidth, innerHeight } = window;

document.body.innerHTML = `<canvas width="${innerWidth}" height="${innerHeight}"></canvas>`;

const canvas = document.querySelector('canvas');
const { width, height } = canvas;

const COLOR_MIN = 55;
const COLOR_MAX = 255;
const ODDS_FIREWORK = 100;
const ODDS_FIREWORK_HEART = 5;
const GRAVITY = 2;
const VELOCITY_MIN = 1;
const VELOCITY_MAX = 3;

const PARTICLE_VELOCITY = 0.2;
const PARTICLE_GRAVITY = 0.2;

