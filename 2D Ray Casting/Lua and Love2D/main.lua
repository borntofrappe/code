require "Boundary"
require "Ray"
WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("2D Ray Casting")
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  wall = Boundary:create(WINDOW_WIDTH * 3 / 4, WINDOW_HEIGHT / 4, WINDOW_WIDTH * 3 / 4 + 20, WINDOW_HEIGHT * 3 / 4)
  ray = Ray:create(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)

  point = ray:cast(wall)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update()
  local x, y = love.mouse:getPosition()
  if x ~= 0 and y ~= 0 then
    ray:lookAt(x, y)
    point = ray:cast(wall)
  end
end

function love.draw()
  wall:render()
  ray:render()

  if point then
    love.graphics.setColor(0.2, 0.95, 0.72)
    love.graphics.circle("fill", point.x, point.y, 5)
  end
end
