const canvas = document.querySelector('canvas');
const context = canvas.getContext('2d');
const { width, height } = canvas;

const LINE_WIDTH_BOUNDARY = 8;
const LINE_WIDTH_RAY = 3;
const LINE_WIDTH_PARTICLE = 3;
const RADIUS_PARTICLE = 10;
const SEGMENTS = 5;

// SET UP CLASSES
/* Boundary
- draw a line from point to point
*/
class Boundary {
  constructor(x1, y1, x2, y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }

  draw() {
    context.lineWidth = LINE_WIDTH_BOUNDARY;
    context.strokeStyle = '#ffffff';
    context.beginPath();
    context.moveTo(this.x1, this.y1);
    context.lineTo(this.x2, this.y2);
    context.stroke();
  }
}

/* Ray
- draw a line from a point
- compute the point of intersection with an input line (if any)
*/
class Ray {
  constructor(x, y, angle) {
    const direction = {
      x: Math.cos(angle),
      y: Math.sin(angle),
    };

    this.x = x;
    this.y = y;
    this.direction = direction;
  }

  draw() {
    context.lineWidth = LINE_WIDTH_RAY;
    context.strokeStyle = '#ffffff';
    context.beginPath();
    context.moveTo(this.x, this.y);
    context.lineTo(
      this.x + this.direction.x * 10,
      this.y + this.direction.y * 10
    );
    context.stroke();
  }

  cast(boundary) {
    const { x1 } = boundary;
    const { y1 } = boundary;
    const { x2 } = boundary;
    const { y2 } = boundary;

    const x3 = this.x;
    const y3 = this.y;
    const x4 = this.x + this.direction.x;
    const y4 = this.y + this.direction.y;

    const denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

    if (denominator === 0) {
      return null;
    }
    const t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator;
    const u =
      (((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denominator) * -1;
    if (t > 0 && t < 1 && u > 0) {
      return {
        x: x1 + t * (x2 - x1),
        y: y1 + t * (y2 - y1),
      };
    }
    return null;
  }
}

/* Ray
- initialize a series of rays
// - draw rays
- draw an ellipse
- compute the points of intersection between each ray and the closest of the input lines (if any)
- move according to input coordinates
*/
class Particle {
  constructor(x, y) {
    const rays = [];
    for (let i = 0; i < 360; i += 1) {
      const angle = (i * Math.PI) / 180;
      rays.push(new Ray(x, y, angle));
    }
    this.x = x;
    this.y = y;
    this.rays = rays;
  }

  draw() {
    // for(const ray of this.rays) {
    //   ray.draw();
    // }

    context.fillStyle = '#ffffff';
    context.strokeStyle = '#00000022';
    context.lineWidth = LINE_WIDTH_PARTICLE;
    context.beginPath();
    context.arc(this.x, this.y, RADIUS_PARTICLE, 0, Math.PI * 2, false);
    context.fill();
    context.stroke();
  }

  cast(boundaries) {
    const points = [];
    for (const ray of this.rays) {
      let closestPoint = null;
      let closestDistance = null;
      for (const boundary of boundaries) {
        const point = ray.cast(boundary);
        if (point) {
          const distance =
            ((point.x - this.x) ** 2 + (point.y - this.y) ** 2) ** 0.5;
          if (!closestDistance || distance < closestDistance) {
            closestDistance = distance;
            closestPoint = point;
          }
        }
      }
      if (closestPoint) {
        points.push(closestPoint);
      }
    }
    return points;
  }

  move(x, y) {
    this.x = x;
    this.y = y;
    for (const ray of this.rays) {
      ray.x = x;
      ray.y = y;
    }
  }
}

// BOUNDARIES: include four lines for the canvas's edges and SEGMENTS lines at random
const walls = [];
walls.push(new Boundary(0, 0, width, 0));
walls.push(new Boundary(width, 0, width, height));
walls.push(new Boundary(width, height, 0, height));
walls.push(new Boundary(0, height, 0, 0));

for (let i = 0; i < SEGMENTS; i += 1) {
  const x1 = Math.round(Math.random() * width);
  const y1 = Math.round(Math.random() * height);
  const x2 = Math.round(Math.random() * width);
  const y2 = Math.round(Math.random() * height);
  walls.push(new Boundary(x1, y1, x2, y2));
}

// PARTICLE: include a particle in the center of the canvas
const particle = new Particle(width / 2, height / 2);

// POINTS: compute the coordinates for the points of intersections
// _let_ since the points are computed once more as the particle is moved 
let points = particle.cast(walls);

// DRAW OPERATIONS
// repeat every time the particle is moved and the points are re-computed
function draw() {
  context.clearRect(0, 0, width, height);

  for (const wall of walls) {
    wall.draw();
  }

  if (points.length > 0) {
    context.lineWidth = LINE_WIDTH_RAY;
    context.strokeStyle = '#ffffff55';
    for (const point of points) {
      context.beginPath();
      context.moveTo(particle.x, particle.y);
      context.lineTo(point.x, point.y);
      context.stroke();
    }
  }

  particle.draw();
}

draw();

// allow to move the particle and update the canvas only when dragging the cursor
let isDragging = false;

const { x: offsetX, y: offsetY } = canvas.getBoundingClientRect();
canvas.addEventListener('mousemove', e => {
  const { x, y } = e;
  const canvasX = x - offsetX;
  const canvasY = y - offsetY;

  if (
    (canvasX - particle.x) ** 2 + (canvasY - particle.y) ** 2 <
    RADIUS_PARTICLE ** 2
  ) {
    document.body.style.cursor = 'grab';
  } else {
    document.body.style.cursor = 'initial';
  }

  if (isDragging) {
    particle.move(canvasX, canvasY);
    points = particle.cast(walls);
    draw();
  }
});

canvas.addEventListener('mousedown', e => {
  const { x, y } = e;
  const canvasX = x - offsetX;
  const canvasY = y - offsetY;
  isDragging =
    (canvasX - particle.x) ** 2 + (canvasY - particle.y) ** 2 <
    RADIUS_PARTICLE ** 2;
});

canvas.addEventListener('mouseup', () => (isDragging = false));
canvas.addEventListener('mouseleave', () => (isDragging = false));
