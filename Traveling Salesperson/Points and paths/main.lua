LVector = require "LVector"
require "Point"
require "Path"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

POINTS = 5
POINT_RADIUS = 5

LINE_WIDTH = 1

function love.load()
  love.window.setTitle("Traveling salesperson - Points and paths")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.07, 0.07, 0.07)

  math.randomseed(os.time())

  points = getPoints(POINTS)
  paths = getPaths(points)
  recordDistance = getTotalDistance(points)
end

function swap(t, i, j)
  local temp = t[i]
  t[i] = t[j]
  t[j] = temp
end

function getPoints(n)
  local n = n or POINTS
  local points = {}

  for i = 1, n do
    table.insert(points, Point:new())
  end

  return points
end

function getPaths(points)
  local paths = {}

  for i = 1, #points - 1 do
    table.insert(
      paths,
      Path:new(points[i].position.x, points[i].position.y, points[i + 1].position.x, points[i + 1].position.y)
    )
  end

  return paths
end

function getTotalDistance(points)
  local totalDistance = 0

  for i = 1, #points - 1 do
    local dir = LVector:subtract(points[i].position, points[i + 1].position)
    totalDistance = totalDistance + dir:getMagnitude()
  end

  return totalDistance
end

function love.mousepressed(x, y, button)
  if button == 2 then
    points = getPoints()
    paths = getPaths(points)
    recordDistance = getTotalDistance(points)
  end
end

function love.update(dt)
  if love.mouse.isDown(1) then
    local index1 = math.random(#points)
    local index2
    repeat
      index2 = math.random(#points)
    until index1 ~= index2

    swap(points, index1, index2)

    paths = getPaths(points)
    local totalDistance = getTotalDistance(points)
    if totalDistance < recordDistance then
      recordDistance = totalDistance
    end
  end
end

function love.draw()
  love.graphics.setColor(0.97, 0.97, 0.97, 1)
  love.graphics.print("Record distance: " .. string.format("%d", recordDistance))
  for i, path in ipairs(paths) do
    path:render()
  end

  for i, point in ipairs(points) do
    point:render()
  end
end
