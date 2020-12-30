require "Particle"

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400
RADIUS_PARTICLE = 3
PARTICLES = 8
VELOCITY_MIN = 380
VELOCITY_MAX = 580
GRAVITY = 450

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Fireworks")
  love.graphics.setBackgroundColor(0.07, 0.07, 0.07)

  particles = {}
  for i = 1, PARTICLES do
    table.insert(particles, Particle:create())
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  for i = #particles, 1, -1 do
    local particle = particles[i]
    particle:update(dt)
    if particle.position.y - RADIUS_PARTICLE > WINDOW_HEIGHT then
      table.remove(particles, i)
      table.insert(particles, Particle:create())
    end
  end
end

function love.draw()
  for i, particle in ipairs(particles) do
    particle:render()
  end
end
