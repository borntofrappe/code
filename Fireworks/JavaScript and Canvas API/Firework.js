class Firework {
  constructor() {
    this.hasExpired = false;
    this.hasExploded = false;

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

    this.particle = new Particle(position, velocity, acceleration, 3, false);
    this.fragments = [];
  }

  update() {
    this.particle.update();

    if(!this.hasExploded) {
      if(this.particle.velocity.y > 0 && this.particle.velocity.y < 0.5) [
        this.particle.r = Math.max(0, this.particle.r - 0.02)
      ]
      if(this.particle.velocity.y > 0.5) {
        this.hasExploded = true;
        for(let i = 0; i < 360; i += 1) {
          const angle = i / 180 * Math.PI;
          const position = {
            x: this.particle.position.x,
            y: this.particle.position.y
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
          this.fragments.push(new Fragment(position, velocity, acceleration,2, true))
        }
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
    context.fillStyle = 'rgb(255, 255, 255)';
    if(!this.hasExploded) {
      this.particle.show(context);
    } else {
      for(const fragment of this.fragments) {
        fragment.show(context);
      }
    }
  }
}
