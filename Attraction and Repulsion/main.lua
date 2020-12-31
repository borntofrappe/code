require "Particle"

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400
RADIUS_PARTICLE = 3

function love.load()
  love.window.setTitle("Attraction Pattern")
  love.graphics.setBackgroundColor(0.07, 0.07, 0.07)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  local position = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT / 2
  }

  local velocity = {
    ["x"] = 0,
    ["y"] = -5
  }

  local acceleration = {
    ["x"] = 0,
    ["y"] = 2
  }

  particle = Particle:create(RADIUS_PARTICLE, position, velocity, acceleration)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  particle:update(dt)
end

function love.draw()
  particle:render()
end
