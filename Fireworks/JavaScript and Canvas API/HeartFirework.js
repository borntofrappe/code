class HeartFirework extends Firework {
  constructor() {
    super();
  }

  getFragments(x, y) {
    const fragments = [];
    for(let i = 0; i < 360; i += 1) {
      const angle = degreesToRadians(i);
      const position = {
        x,
        y
      }
      // TODO HERE
      const vx = 16 * Math.sin(angle) ** 3
      const vy = (13 * Math.cos(angle) - 5 * Math.cos(2 * angle) - Math.cos(3 * angle) - Math.cos(4 * angle))
      const velocity = {
        x: vx * fragmentVelocity * FRAGMENT_HEART_VELOCITY * (Math.random() * FRAGMENT_HEART_VELOCITY_CHANGE_MAX + (1 - FRAGMENT_HEART_VELOCITY_CHANGE_MAX / 2)),
        y: vy * fragmentVelocity * FRAGMENT_HEART_VELOCITY * (Math.random() * FRAGMENT_HEART_VELOCITY_CHANGE_MAX + (1 - FRAGMENT_HEART_VELOCITY_CHANGE_MAX / 2)) * -1,
      }
      fragments.push(new Fragment(position, velocity))
    }

    return fragments;
  }
}