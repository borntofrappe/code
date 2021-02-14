class Fragment extends Particle {
  constructor(position, velocity, acceleration, r) {
    super(position, velocity, acceleration, r);
  }

  update() {
    super.update();
    this.r = Math.max(0, this.r - 0.04);
  }
}