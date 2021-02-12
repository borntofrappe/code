class Particle {
  constructor(position, target, r) {
    this.position = position;
    this.target = target;
    this.r = r;
    this.velocity = VLib.new(0, 0);
    this.acceleration = VLib.new(0, 0);
  }

  show(context) {
    context.beginPath();
    context.arc(this.position.x, this.position.y, this.r, 0, Math.PI * 2);
    context.fill();
    context.closePath();
  }

  update() {
    this.position.add(this.velocity);
    this.velocity.add(this.acceleration);

    const dirTarget = VLib.subtract(this.target, this.position);
    const distanceTarget = dirTarget.getMagnitude();
    this.velocity.limit(distanceTarget ** 0.3);
    this.acceleration.multiply(0);
  }

  applyForce(force) {
    this.acceleration.add(force);
  }

  applyBehaviours(mouse) {
    const dirTarget = VLib.subtract(this.target, this.position);
    const distanceTarget = dirTarget.getMagnitude();
    if (distanceTarget > this.r) {
      this.applyForce(this.steer(dirTarget, distanceTarget));
      this.applyForce(this.getFriction());
    }

    if (mouse) {
      const dirMouse = VLib.subtract(mouse, this.position);
      const disMouse = dirMouse.getMagnitude();
      if (disMouse < this.r * 6) {
        this.applyForce(this.repelMouse(dirMouse, disMouse));
      }
    }
  }

  steer(force, distance) {
    force.normalize();
    const randomNoise = VLib.new(Math.random() - 0.5, Math.random() - 0.5);
    force.add(randomNoise);
    force.multiply(distance);
    return force;
  }

  repelMouse(force, distance) {
    force.normalize();
    force.multiply(distance * 100 * -1);
    return force;
  }

  getFriction() {
    const force = VLib.copy(this.velocity);
    force.multiply(-1);
    force.multiply(0.75);
    return force;
  }

  updateTarget(target) {
    this.target = target;
  }

  resize(size) {
    const { r } = this;
    this.position.multiply(size / r);
    this.target.multiply(size / r);
    this.r = size;
  }
}
