require "Boundary"
require "Ray"
require "Particle"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("2D Ray Casting")
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  wall = Boundary:create(WINDOW_WIDTH * 3 / 4, WINDOW_HEIGHT / 4, WINDOW_WIDTH * 3 / 4 + 20, WINDOW_HEIGHT * 3 / 4)
  particle = Particle:create(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)

  points = particle:cast(wall)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update()
  local x, y = love.mouse:getPosition()
  if x ~= 0 and y ~= 0 then
    particle:move(x, y)
    points = particle:cast(wall)
  end
end

function love.draw()
  wall:render()
  particle:render()

  if #points > 0 then
    love.graphics.setColor(1, 1, 1, 1)
    for i, point in ipairs(points) do
      love.graphics.line(particle.x, particle.y, point.x, point.y)
    end
  end
end
