require "Particle"
require "Attractor"

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400
RADIUS_PARTICLE = 4
RADIUS_ATTRACTOR = 4
GRAVITATIONAL_CONSTANT = 50000

function love.load()
  love.window.setTitle("Attraction Pattern")
  love.graphics.setBackgroundColor(0.07, 0.07, 0.07)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  local positionParticle = {
    ["x"] = love.math.random(WINDOW_WIDTH),
    ["y"] = love.math.random(WINDOW_HEIGHT)
  }

  local velocityParticle = {
    ["x"] = love.math.random(-50, 50),
    ["y"] = love.math.random(-50, 50)
  }

  local accelerationParticle = {
    ["x"] = 0,
    ["y"] = 0
  }

  local positionAttractor = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT / 2
  }

  particle = Particle:create(RADIUS_PARTICLE, positionParticle, velocityParticle, accelerationParticle)

  attractor = Attractor:create(RADIUS_ATTRACTOR, positionAttractor)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  particle:attract(attractor)
  particle:update(dt)
end

function love.draw()
  particle:render()
  attractor:render()
end
