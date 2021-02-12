class ParticleSystem {
  constructor(key, size) {
    const strings = {
      rocket: `xxxxxxxxxxxxxxxxxxxx
    xxxxxxxxxxxxooooooxx
    xxxxxxxxxxooooooooox
    xxxxxxxxxoooxxxxxoox
    xxxxxxxoooxxxxxxxoox
    xooooooooxxxxxxxxoox
    xooxxoooxxoooxxxxoox
    xxoxxooxxooxooxxxoox
    xxooooxxxoxxxoxxooxx
    xxxoooxxxoxxooxxooxx
    xxxxoooxxooooxxooxxx
    xxxoooooxxxxxxooxxxx
    xxxooxoooxxxxoooxxxx
    xxxoxxxoooxxoooxxxxx
    xxxoxxxxoooooooxxxxx
    xxxooxxoooooxxoxxxxx
    xxxooooooxooxxoxxxxx
    xxxxxxxxxxxooooxxxxx
    xxxxxxxxxxxxxooxxxxx
    xxxxxxxxxxxxxxxxxxxx`,
      codepen: `xxxxxxxxxxxxxxxxxxxx
    xxxxxxxxxooxxxxxxxxx
    xxxxxxxooooooxxxxxxx
    xxxxxoooxooxoooxxxxx
    xxxoooxxxooxxxoooxxx
    xooooxxxxooxxxxoooox
    oooxxxxxxooxxxxxxooo
    ooooxxxxxooxxxxxxooo
    oooooxxxooooxxxooooo
    ooxxoooooxxoooooxxoo
    ooxxoooooxxoooooxxoo
    oooooxxxooooxxxooooo
    oooxxxxxxooxxxxxxooo
    xoooxxxxxooxxxxxooox
    xxoooxxxxooxxxxoooxx
    xxxxoooxxooxxoooxxxx
    xxxxxxooooooooxxxxxx
    xxxxxxxooooooxxxxxxx
    xxxxxxxxxooxxxxxxxxx
    xxxxxxxxxxxxxxxxxxxx`,
      blog: `xxxxxxxxxxxxxxxxxxxx
    xxxxxxxxxxxxxxxxxxxx
    xoooooooooooooxxxxxx
    ooxxooxxxxxxxooxxxxx
    oxxxxooxxxxxxoooxxxx
    oooooooxxxxxxxooxxxx
    oooooooxooooxxooxxxx
    xxxxxooxxxxxxxooxxxx
    xxxxxooxooxxxxooxxxx
    xxxxxooxxxxxxxooxxxx
    xxxxxooxoooxxxooxxxx
    xxxxxooxxxxxxxooxxxx
    xxxxxooxoxxxxxooxxxx
    xxxxxooxxxoooooooooo
    xxxxxooxxxoooooooooo
    xxxxxooxxxoxxxxxxxoo
    xxxxxooooooxxxxxxooo
    xxxxxxooooooooooooox
    xxxxxxxxxxxxxxxxxxxx
    xxxxxxxxxxxxxxxxxxxx`,
      freecodecamp: `xxxxxxxxxxxxxxxxxxxx
    xxxxxxxxxxxxxxxxxxxx
    xxxooxxxxxxxxxxooxxx
    xxooxxxooxxxxxxxooxx
    xooxxxxxooxxxxxxxoox
    xooxxxxxooxxxxxxxoox
    xooxxxxxoooxxxxxxoox
    ooxxxxxooooxoxxxxxoo
    ooxxxxoooxoxooxxxxoo
    ooxxxxooxxoxoooxxxoo
    ooxxxooxxxoooooxxxoo
    ooxxxooxxxooxooxxxoo
    ooxxxooxxxxxxooxxxoo
    ooxxxooxxxxxxooxxxoo
    xooxxxooxxxxooxxxoox
    xoooxxxooooooxxxooox
    xxooxxxxooooxxxxooxx
    xxxooxxxxxxxxxxooxxx
    xxxxxxxxxxxxxxxxxxxx
    xxxxxxxxxxxxxxxxxxxx`,
      github: `xxxxxxxxxxxxxxxxxxxx
    xxxoooxxxooxxxoooxxx
    xxooxooooooooooxooxx
    xxooxxxxxxxxxxxxooxx
    xxxooxxxxxxxxxxooxxx
    xxxooxxxxxxxxxxooxxx
    xxooxxxxxxxxxxxxooxx
    xxooxxxxxxxxxxxxooxx
    xxooxxxxxxxxxxxxooxx
    xxooxxxxxxxxxxxxooxx
    xxxooxxxxxxxxxxooxxx
    xxxxoooooooooooooxxx
    xxxxxoooooooooooxxxx
    xxxxxoxxxxxxxxooxxxx
    xxxxooxoxooxoxooxxxx
    xxxxoxxoxooxoxxoxxxx
    xxxxoxooxooxooxoxxxx
    xxxooooooooooooooxxx
    xxoooxxooxxooxxoooxx
    xxxxxxxxxxxxxxxxxxxx`,
      twitter: `xxxxxxxxxxxxxxxxxxxx
    xxxxxxxxxxxooooxxxxx
    xxxxxxxxxxooooooxxxx
    xoxxxxxxxooxxxxooxxx
    xoooxxxxxooxxxxxoooo
    xooooxxxxooxxxxxxoox
    xooxoooooooxxxxxooxx
    oxooxxooooxxxxxxooxx
    oooooxxxxxxxxxxxooxx
    ooooooxxxxxxxxxxooxx
    xooxxxxxxxxxxxxxooxx
    oooooxxxxxxxxxxxooxx
    xoooxxxxxxxxxxxooxxx
    xxoooxxxxxxxxxooxxxx
    xxxooooxxxxxxoooxxxx
    xoooooxxxxxxoooxxxxx
    xxoooxxxxxxoooxxxxxx
    xxxooooooooooxxxxxxx
    xxxxxooooooxxxxxxxxx
    xxxxxxxxxxxxxxxxxxxx`,
    };

    const string = strings[key];
    const gridOffset = size * 0.15;
    const gridSize = size - gridOffset * 2;
    const gridDimensions = string.indexOf('\n');
    const cellSize = Math.floor(gridSize / gridDimensions);
    const particleRadius = Math.floor(cellSize / 2) * 0.9;
    const singleLineString = string.replace(/\s/g, '');

    const particles = [];
    for (let i = 0; i < singleLineString.length; i += 1) {
      if (singleLineString[i] === 'o') {
        const column = i % gridDimensions;
        const row = Math.floor(i / gridDimensions);

        const x = column * cellSize + cellSize / 2 + gridOffset;
        const y = row * cellSize + cellSize / 2 + gridOffset;

        const position = VLib.new(
          Math.floor(Math.random() * gridSize) + gridOffset,
          Math.floor(Math.random() * gridSize) + gridOffset
        );
        const target = VLib.new(x, y);

        particles.push(new Particle(position, target, particleRadius));
      }
    }

    this.strings = strings;
    this.key = key;
    this.gridOffset = gridOffset;
    this.gridDimensions = gridDimensions;
    this.cellSize = cellSize;
    this.particleRadius = particleRadius;
    this.particles = particles;
  }

  show(context) {
    for (const particle of this.particles) {
      particle.show(context);
    }
  }

  update(mouse) {
    for (const particle of this.particles) {
      particle.update();
      particle.applyBehaviours(mouse);
    }
  }

  updateParticles(key) {
    const string = this.strings[key];
    this.key = key;
    const singleLineString = string.replace(/\s/g, '');
    const targets = [];

    for (let i = 0; i < singleLineString.length; i += 1) {
      if (singleLineString[i] === 'o') {
        const column = i % this.gridDimensions;
        const row = Math.floor(i / this.gridDimensions);

        const x = column * this.cellSize + this.cellSize / 2 + this.gridOffset;
        const y = row * this.cellSize + this.cellSize / 2 + this.gridOffset;
        targets.push(VLib.new(x, y));
      }
    }

    for (let i = 0; i < targets.length; i += 1) {
      if (i < this.particles.length) {
        this.particles[i].updateTarget(targets[i]);
      } else {
        const position = VLib.copy(
          this.particles[this.particles.length - 1].position
        );
        this.particles.push(
          new Particle(position, targets[i], this.particleRadius)
        );
      }
    }

    if (this.particles.length > targets.length) {
      const gap = this.particles.length - targets.length;
      for (let i = 1; i < gap; i += 1) {
        this.particles.pop();
      }
    }
  }

  resize(size) {
    const gridOffset = size * 0.15;
    const gridSize = size - gridOffset * 2;
    const { gridDimensions } = this;
    const cellSize = Math.floor(gridSize / gridDimensions);
    const particleRadius = Math.floor(cellSize / 2) * 0.9;

    for (const particle of this.particles) {
      particle.resize(particleRadius);
    }

    this.gridOffset = gridOffset;
    this.gridSize = gridSize;
    this.cellSize = cellSize;
    this.particleRadius = particleRadius;
  }
}
