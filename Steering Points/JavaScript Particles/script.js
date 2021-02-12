const keys = ['rocket', 'blog', 'codepen', 'freecodecamp', 'github', 'twitter'];
const initialKey = keys[0];

document.body.innerHTML = `<main>
  <canvas width="400" height="400"></canvas>

  <section>
    ${keys
      .map(
        key => `
    <a href="#" class="${key === initialKey ? 'active' : ''}">
      ${key}
    </a>`
      )
      .join('')}
  </section>
</main>`;

const canvas = document.querySelector('main canvas');
let { width: size } = canvas.getBoundingClientRect();
canvas.width = size;
canvas.height = size;
const context = canvas.getContext('2d');

const links = document.querySelectorAll('main section a');

let mouse = null;
const VLib = new VectorLib();

const particleSystem = new ParticleSystem(initialKey, size);
particleSystem.show(context);

function animate() {
  context.clearRect(0, 0, size, size);

  particleSystem.update(mouse);
  particleSystem.show(context);

  requestAnimationFrame(animate);
}

animate();

canvas.addEventListener('mousemove', function(e) {
  const { left, top } = this.getBoundingClientRect();
  const { pageX, pageY } = e;

  const x = pageX - left;
  const y = pageY - top;
  mouse = VLib.new(x, y);
});

canvas.addEventListener('mouseleave', function() {
  mouse = null;
});

window.addEventListener('keypress', function(e) {
  const { key: k } = e;

  for (const key of Object.keys(particleSystem.strings)) {
    if (key[0] === k && key !== particleSystem.key) {
      particleSystem.updateParticles(key);

      links.forEach(link =>
        link.textContent.trim() === key
          ? link.classList.add('active')
          : link.classList.remove('active')
      );
      break;
    }
  }
});

window.addEventListener('resize', function() {
  const { width } = canvas.getBoundingClientRect();
  size = width;
  canvas.width = size;
  canvas.height = size;

  particleSystem.resize(size);
  particleSystem.show(context);
});

links.forEach(link =>
  link.addEventListener('mouseenter', function() {
    const key = this.textContent.trim();
    particleSystem.updateParticles(key);
    links.forEach(l =>
      l.textContent.trim() === key
        ? l.classList.add('active')
        : l.classList.remove('active')
    );
  })
);
