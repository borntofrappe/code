class Fragment extends Particle {
  constructor(position, velocity) {
    const acceleration = {x: 0, y: fragmentGravity}
    const r = FRAGMENT_RADIUS;
    super(position, velocity, acceleration, r);
  }

  update() {
    super.update();
    this.r = Math.max(0, this.r - FRAGMENT_RADIUS_DECREASE);
  }
}