require "Particle"
require "Attractor"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

PARTICLES_MAX = 50
ODDS_PARTICLE = 20
RADIUS_PARTICLE = 4

ATTRACTORS_MAX = 10
RADIUS_ATTRACTOR = 4

GRAVITATIONAL_CONSTANT = 50
DISTANCE_MIN = 2
DISTANCE_MAX = 30
DISTANCE_THRESHOLD = 25
VELOCITY_MAGNITUDE_LIMIT = 5

-- factor multiplying the vectors to scale the measure in delta time
UPDATE_SPEED = 40

function love.load()
  love.window.setTitle("Playground")
  love.graphics.setBackgroundColor(0.07, 0.07, 0.07)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  particles = {}
  attractors = {
    Attractor:create(
      RADIUS_ATTRACTOR,
      {
        ["x"] = WINDOW_WIDTH / 2,
        ["y"] = WINDOW_HEIGHT / 2
      },
      {
        ["r"] = 0.1,
        ["g"] = 0.82,
        ["b"] = 0.6
      }
    )
  }
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    if #attractors > ATTRACTORS_MAX then
      table.remove(attractors, 1)
    end

    local position = {
      ["x"] = x,
      ["y"] = y
    }
    local attractor =
      Attractor:create(
      RADIUS_ATTRACTOR,
      position,
      {
        ["r"] = 0.1,
        ["g"] = 0.82,
        ["b"] = 0.6
      }
    )
    table.insert(attractors, attractor)
  end
end

function love.update(dt)
  for i, particle in ipairs(particles) do
    for j, attractor in ipairs(attractors) do
      particle:attract(attractor)
    end
    particle:update(dt)
  end

  if love.math.random(ODDS_PARTICLE) == 1 then
    if #particles > PARTICLES_MAX then
      table.remove(particles, 1)
    end

    local position = {
      ["x"] = love.math.random(WINDOW_WIDTH),
      ["y"] = love.math.random(WINDOW_HEIGHT)
    }
    local velocity = {
      ["x"] = 0,
      ["y"] = 0
    }
    local acceleration = {
      ["x"] = 0,
      ["y"] = 0
    }

    local particle = Particle:create(RADIUS_PARTICLE, position, velocity, acceleration)
    table.insert(particles, particle)
  end
end

function love.draw()
  for i, particle in ipairs(particles) do
    particle:render()
  end

  for i, attractor in ipairs(attractors) do
    attractor:render()
  end
end
