require "Particle"

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400
RADIUS_PARTICLE = 4

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Fireworks")
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  particle = Particle:create(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
end

function love.draw()
  particle:render()
end
