class Particle {
  constructor(position, velocity, acceleration, r) {
    this.position = position;
    this.velocity = velocity;
    this.acceleration = acceleration;
    this.r = r;
  }

  update() {
    this.position.x = this.position.x + this.velocity.x;
    this.position.y = this.position.y + this.velocity.y;

    this.velocity.x = this.velocity.x + this.acceleration.x;
    this.velocity.y = this.velocity.y + this.acceleration.y;
  }

  show(context) {
    context.beginPath();
    context.arc(this.position.x, this.position.y, this.r, 0, Math.PI * 2);
    context.fill();
    context.closePath();
  }
}
