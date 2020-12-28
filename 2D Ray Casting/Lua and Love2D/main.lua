require "Boundary"
require "Ray"
require "Particle"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("2D Ray Casting")
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  walls = {}
  table.insert(walls, Boundary:create(0, 0, WINDOW_WIDTH, 0))
  table.insert(walls, Boundary:create(WINDOW_WIDTH, 0, WINDOW_WIDTH, WINDOW_HEIGHT))
  table.insert(walls, Boundary:create(WINDOW_WIDTH, WINDOW_HEIGHT, 0, WINDOW_HEIGHT))
  table.insert(walls, Boundary:create(0, WINDOW_HEIGHT, 0, 0))

  for i = 1, 5 do
    local x1 = love.math.random(WINDOW_WIDTH)
    local x2 = love.math.random(WINDOW_WIDTH)
    local y1 = love.math.random(WINDOW_HEIGHT)
    local y2 = love.math.random(WINDOW_HEIGHT)
    table.insert(walls, Boundary:create(x1, y1, x2, y2))
  end

  particle = Particle:create(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  points = particle:cast(walls)
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
    points = particle:cast(walls)
  end
end

function love.draw()
  for i, wall in ipairs(walls) do
    wall:render()
  end

  particle:render()

  if #points > 0 then
    love.graphics.setColor(1, 1, 1, 1)
    for i, point in ipairs(points) do
      love.graphics.line(particle.x, particle.y, point.x, point.y)
    end
  end
end
