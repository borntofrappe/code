class Particle {
  constructor(r, position, velocity, acceleration, color) {
    this.r = r;
    this.position = position;
    this.velocity = velocity;
    this.acceleration = acceleration;
    this.color = color;
  }

  update() {
    this.position.x = this.position.x + this.velocity.x;
    this.position.y = this.position.y + this.velocity.y;
   
    this.velocity.x = this.velocity.x + this.acceleration.x;
    this.velocity.y = this.velocity.y + this.acceleration.y;
  }

  show(context) {
    context.fillStyle = this.color;
    context.beginPath();
    context.arc(this.position.x, this.position.y, this.position.r, 0, Math.PI * 2);
    context.closePath();
  }
}
