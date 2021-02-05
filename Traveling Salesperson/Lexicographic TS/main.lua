LVector = require "LVector"
require "Point"
require "Path"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

POINTS = 6
POINT_RADIUS = 5

LINE_WIDTH = 2

function love.load()
  love.window.setTitle("Traveling salesperson - Lexicographic TS")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.07, 0.07, 0.07)

  math.randomseed(os.time())

  points = getPoints(POINTS)
  indexes = {}
  for i = 1, #points do
    table.insert(indexes, i)
  end
  paths = getPaths(points, indexes)
  recordDistance = getTotalDistance(points, indexes)

  permutations = factorial(#points)
  permutationsCount = 0

  hasFinished = false
end

function love.mousepressed(x, y, button)
  if button == 1 then
    hasFinished = true

    points = getPoints(POINTS)
    indexes = {}
    for i = 1, #points do
      table.insert(indexes, i)
    end
    paths = getPaths(points, indexes)
    recordDistance = getTotalDistance(points, indexes)

    permutationsCount = 0

    hasFinished = false
  end
end

function factorial(n)
  if n == 1 then
    return 1
  end
  return n * factorial(n - 1)
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

function getPaths(points, indexes)
  local paths = {}

  for i = 1, #indexes - 1 do
    table.insert(
      paths,
      Path:new(
        points[indexes[i]].position.x,
        points[indexes[i]].position.y,
        points[indexes[i + 1]].position.x,
        points[indexes[i + 1]].position.y
      )
    )
  end

  return paths
end

function getTotalDistance(points, indexes)
  local totalDistance = 0

  for i = 1, #indexes - 1 do
    local dir = LVector:subtract(points[indexes[i]].position, points[indexes[i + 1]].position)
    totalDistance = totalDistance + dir:getMagnitude()
  end

  return totalDistance
end

function love.update(dt)
  if not hasFinished then
    permutationsCount = permutationsCount + 1

    local index1 = 0

    for i = 1, #indexes - 1 do
      if indexes[i] < indexes[i + 1] then
        index1 = i
      end
    end

    if index1 == 0 then
      hasFinished = true
    else
      local index2 = 0
      for i = 1, #indexes do
        if indexes[index1] < indexes[i] then
          index2 = i
        end
      end

      swap(indexes, index1, index2)

      local copy = {}
      for i = 1, #indexes do
        if i < index1 + 1 then
          table.insert(copy, indexes[i])
        else
          table.insert(copy, index1 + 1, indexes[i])
        end
      end

      indexes = copy

      local totalDistance = getTotalDistance(points, indexes)
      if totalDistance < recordDistance then
        recordDistance = totalDistance
        paths = getPaths(points, indexes)
      end
    end
  end
end

function love.draw()
  love.graphics.setColor(0.97, 0.97, 0.97, 1)
  love.graphics.print(string.format("Record distance:  %d", recordDistance), 2, 2)
  love.graphics.print(string.format("Completion rate:  %.2f", permutationsCount / permutations), 2, 18)

  for i, path in ipairs(paths) do
    path:render()
  end

  for i, point in ipairs(points) do
    point:render()
  end
end
