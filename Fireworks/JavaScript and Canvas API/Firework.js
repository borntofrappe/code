class Firework {
  constructor() {
    this.hasExpired = false;
    this.hasExploded = false;
    this.color = `hsl(${Math.floor(Math.random() * 360)}, ${80}%, ${70}%)`;

    const position = {
      x: Math.random() * WINDOW_WIDTH,
      y: WINDOW_HEIGHT
    }

    const vy = Math.random() * (VELOCITY_MAX - VELOCITY_MIN) + VELOCITY_MIN
    const velocity = {
      x: 0,
      y: vy * -1
    }

    const acceleration = {
      x: 0,
      y: GRAVITY
    }

    this.particle = new Particle(position, velocity, acceleration, 4, false);
    this.fragments = [];
  }

  getFragments(x, y) {
    const fragments = [];
    for(let i = 0; i < 360; i += 1) {
      const angle = i / 180 * Math.PI;
      const position = {
        x,
        y
      }
      const distance = Math.random() * PARTICLE_VELOCITY
      const vx = Math.cos(angle) * distance
      const vy = Math.sin(angle) * distance
      const velocity = {
        x: vx,
        y: vy,
      }
      const acceleration = {
        x: 0,
        y: PARTICLE_GRAVITY
      }
      fragments.push(new Fragment(position, velocity, acceleration, 3, true))
    }
    return fragments;
  }

  update() {
    this.particle.update();

    if(!this.hasExploded) {
      if(this.particle.velocity.y > 0 && this.particle.velocity.y < 0.5) [
        this.particle.r = Math.max(0, this.particle.r - 0.02)
      ]
      if(this.particle.velocity.y > 0.5) {
        this.hasExploded = true;
        this.fragments = this.getFragments(this.particle.position.x, this.particle.position.y)
      }
    } else {
      for(const fragment of this.fragments) {
        fragment.update();
        if(fragment.r === 0) {
          this.hasExpired = true;
          break;
        }
      }
    }
  }

  show(context) {
    context.fillStyle = this.color;
    if(!this.hasExploded) {
      this.particle.show(context);
    } else {
      for(const fragment of this.fragments) {
        fragment.show(context);
      }
    }
  }
}
