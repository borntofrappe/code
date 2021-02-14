class HeartFirework extends Firework {
  constructor() {
    super();
  }

  getFragments(x, y) {
    const fragments = [];
    for(let i = 0; i < 360; i += 1) {
      const angle = i / 180 * Math.PI;
      const position = {
        x,
        y
      }
      const vx = 16 * Math.sin(angle) ** 3
      const vy = (13 * Math.cos(angle) - 5 * Math.cos(2 * angle) - Math.cos(3 * angle) - Math.cos(4 * angle))
      const velocity = {
        x: vx * 0.04 * (Math.random() * 0.3 + 0.85),
        y: vy * 0.04 * (Math.random() * 0.3 + 0.85) * -1,
      }
      const acceleration = {
        x: 0,
        y: PARTICLE_GRAVITY
      }
      fragments.push(new Fragment(position, velocity, acceleration, 3, true))
    }

    return fragments;
  }
}