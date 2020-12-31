require "Particle"
require "Attractor"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

PARTICLES = 10
RADIUS_PARTICLE = 3
LINE_WIDTH_PARTICLE = 1
OPACITY_TRAIL = 0.15

RADIUS_ATTRACTOR = 4

GRAVITATIONAL_CONSTANT = 7500
DISTANCE_MIN = 200
DISTANCE_MAX = 500

X_MIN = math.floor(WINDOW_WIDTH / 6)
X_MAX = math.floor(WINDOW_WIDTH / 5)
Y_MIN = math.floor(WINDOW_HEIGHT / 6)
Y_MAX = math.floor(WINDOW_HEIGHT / 5)
VELOCITY_X_MIN = 20
VELOCITY_X_MAX = 50
VELOCITY_Y_MIN = 10
VELOCITY_Y_MAX = 40
HISTORY_MAX = 2000

function love.load()
  love.window.setTitle("Attraction Pattern")
  love.graphics.setBackgroundColor(0.07, 0.07, 0.07)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  particles = {}

  for i = 1, PARTICLES do
    local px = love.math.random(X_MIN, X_MAX)
    local py = love.math.random(Y_MIN, Y_MAX)
    local position = {
      ["x"] = love.math.random(2) == 1 and px or px * -1,
      ["y"] = love.math.random(2) == 1 and py or py * -1
    }

    local vx = love.math.random(VELOCITY_X_MIN, VELOCITY_X_MAX)
    local vy = love.math.random(VELOCITY_Y_MIN, VELOCITY_Y_MAX)
    local velocity = {
      ["x"] = love.math.random(2) == 1 and vx or vx * -1,
      ["y"] = love.math.random(2) == 1 and vy or vy * -1
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
  attractor:render()
end
