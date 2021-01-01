require "Particle"
require "Attractor"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

PARTICLES = 10
RADIUS_PARTICLE = 2
LINE_WIDTH_PARTICLE = 0.5
OPACITY_TRAIL = 0.2

-- ultimately I chose not to render the attractor, but if it were, it would have this radius
RADIUS_ATTRACTOR = 4

GRAVITATIONAL_CONSTANT = 50
DISTANCE_MIN = 2
DISTANCE_MAX = 20
VELOCITY_MAGNITUDE_LIMIT = 5

ORIGIN_MIN = math.floor(WINDOW_WIDTH / 5)
ORIGIN_MAX = math.floor(WINDOW_WIDTH / 4)
VELOCITY_MIN = 5
VELOCITY_MAX = 20

TRAIL_MAX = 1000

-- factor multiplying the vectors to scale the measure in delta time
UPDATE_SPEED = 30

function love.load()
  love.window.setTitle("Gravitational Attraction Pattern")
  love.graphics.setBackgroundColor(0.07, 0.07, 0.07)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  particles = {}

  for i = 1, PARTICLES do
    local anglePosition = love.math.random(360)
    local origin = love.math.random(ORIGIN_MIN, ORIGIN_MAX)
    local px = math.cos(math.rad(anglePosition)) * origin
    local py = math.sin(math.rad(anglePosition)) * origin
    local position = {
      ["x"] = px,
      ["y"] = py
    }

    local angleVelocity = love.math.random(360)
    local velocity = love.math.random(VELOCITY_MIN, VELOCITY_MAX)
    local vx = math.cos(math.rad(angleVelocity)) * velocity
    local vy = math.sin(math.rad(angleVelocity)) * velocity
    local velocity = {
      ["x"] = vx,
      ["y"] = vy
    }

    local acceleration = {
      ["x"] = 0,
      ["y"] = 0
    }

    particle = Particle:create(RADIUS_PARTICLE, position, velocity, acceleration)
    table.insert(particles, particle)
  end

  attractor =
    Attractor:create(
    RADIUS_ATTRACTOR,
    {
      ["x"] = 0,
      ["y"] = 0
    }
  )
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  for i, particle in ipairs(particles) do
    particle:attract(attractor)
    particle:update(dt)
  end
end

function love.draw()
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  for i, particle in ipairs(particles) do
    particle:render()
  end

  -- attractor:render()
end
