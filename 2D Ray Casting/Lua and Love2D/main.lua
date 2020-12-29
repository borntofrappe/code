require "Boundary"
require "Ray"
require "Particle"

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400
SEGMENTS = 5
LINE_WIDTH_RAY = 3
LINE_WIDTH_BOUNDARY = 5
OPACITY_RAY = 0.5
RADIUS_PARTICLE = 8
OPACITY_PARTICLE = 0.5

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("2D Ray Casting")
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  walls = getBoundaries()
  particle = Particle:create(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  points = particle:cast(walls)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    walls = getBoundaries()
    points = particle:cast(walls)
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
    love.graphics.setColor(1, 1, 1, OPACITY_RAY)
    love.graphics.setLineWidth(LINE_WIDTH_RAY)
    for i, point in ipairs(points) do
      love.graphics.line(particle.x, particle.y, point.x, point.y)
    end
  end
end

function getBoundaries()
  local boundaries = {}
  -- window's edges
  table.insert(boundaries, Boundary:create(0, 0, WINDOW_WIDTH, 0))
  table.insert(boundaries, Boundary:create(WINDOW_WIDTH, 0, WINDOW_WIDTH, WINDOW_HEIGHT))
  table.insert(boundaries, Boundary:create(WINDOW_WIDTH, WINDOW_HEIGHT, 0, WINDOW_HEIGHT))
  table.insert(boundaries, Boundary:create(0, WINDOW_HEIGHT, 0, 0))

  -- random segments
  for i = 1, SEGMENTS do
    local x1 = love.math.random(WINDOW_WIDTH)
    local x2 = love.math.random(WINDOW_WIDTH)
    local y1 = love.math.random(WINDOW_HEIGHT)
    local y2 = love.math.random(WINDOW_HEIGHT)
    table.insert(boundaries, Boundary:create(x1, y1, x2, y2))
  end

  return boundaries
end
