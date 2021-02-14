class Firework {
  constructor() {
    this.hasExpired = false;
    this.hasExploded = false;
    this.color = getColor();

    const position = {
      x: Math.random() * width,
      y: height
    }

    const vy = Math.random() * (fireworkVelocityMax - fireworkVelocityMin) + fireworkVelocityMin
    const velocity = {
      x: 0,
      y: vy * -1
    }

    const acceleration = {
      x: 0,
      y: fireworkGravity
    }

    this.particle = new Particle(position, velocity, acceleration, FIREWORK_RADIUS);
    this.fragments = [];
  }

  getFragments(x, y) {
    const fragments = [];
    for(let i = 0; i < 360; i += 1) {
      const angle = degreesToRadians(i);
      const position = {
        x,
        y
      }
      const distance = Math.random() * fragmentVelocity
      const vx = Math.cos(angle) * distance
      const vy = Math.sin(angle) * distance
      const velocity = {
        x: vx,
        y: vy,
      }
      fragments.push(new Fragment(position, velocity))
    }
    return fragments;
  }

  update() {
    this.particle.update();

    if(!this.hasExploded) {
      if(this.particle.velocity.y > 0 && this.particle.velocity.y < fireworkVelocityThreshold) [
        this.particle.r = Math.max(0, this.particle.r - FIREWORK_RADIUS_DECREASE)
      ]
      if(this.particle.velocity.y > fireworkVelocityThreshold) {
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
