Population = {}
Population.__index = Population

function Population:new(size)
  local generation = 0

  local population = {}
  for i = 1, size do
    local indexes = {}
    for index = 1, POINTS do
      local position = math.random(#indexes + 1)
      table.insert(indexes, position, index)
    end
    table.insert(population, indexes)
  end

  local recordDistance = math.huge

  local points = {}
  for i = 1, POINTS do
    table.insert(points, Point:new())
  end

  local paths = {}
  for i = 1, #points - 1 do
    table.insert(
      paths,
      Path:new(points[i].position.x, points[i].position.y, points[i + 1].position.x, points[i + 1].position.y)
    )
  end

  local this = {
    ["size"] = size,
    ["population"] = population,
    ["recordDistance"] = recordDistance,
    ["points"] = points,
    ["paths"] = paths,
    ["generation"] = generation
  }

  setmetatable(this, self)
  return this
end

function Population:render()
  love.graphics.setColor(0.97, 0.97, 0.97, 1)
  love.graphics.print(string.format("Record distance:  %d", self.recordDistance), 2, 2)
  love.graphics.print(string.format("Generation:  %d", self.generation), 2, 16)

  for i, path in ipairs(self.paths) do
    path:render()
  end

  for i, point in ipairs(self.points) do
    point:render()
  end
end

function Population:update(dt)
  local indexes = self:getBestFit()
  local totalDistance = self:getTotalDistance(indexes)
  if totalDistance < self.recordDistance then
    self.recordDistance = totalDistance

    local paths = {}
    for i = 1, #self.points - 1 do
      table.insert(
        paths,
        Path:new(
          self.points[indexes[i]].position.x,
          self.points[indexes[i]].position.y,
          self.points[indexes[i + 1]].position.x,
          self.points[indexes[i + 1]].position.y
        )
      )
    end
    self.paths = paths
  end

  self:generate()
end

function Population:getTotalDistance(indexes)
  local totalDistance = 0

  for i = 1, #indexes - 1 do
    local dir = LVector:subtract(self.points[indexes[i]].position, self.points[indexes[i + 1]].position)
    totalDistance = totalDistance + dir:getMagnitude()
  end

  return totalDistance
end

function Population:getFitness(indexes)
  local fitness = 0
  local distance = self:getTotalDistance(indexes)
  return 1 / distance
end

function Population:getBestFit()
  local bestIndexesIndex = nil
  local bestIndexesFitness = 0

  for i, indexes in ipairs(self.population) do
    local fitness = self:getFitness(indexes)
    if not bestIndexesIndex or fitness > bestIndexesFitness then
      bestIndexesIndex = i
      bestIndexesFitness = fitness
    end
  end

  return self.population[bestIndexesIndex]
end

function Population:select(maxFitness)
  while true do
    local indexes = self.population[math.random(#self.population)]
    local fitness = self:getFitness(indexes)
    fitness = fitness ^ 2
    local probability = math.random() * maxFitness
    if probability < fitness then
      return indexes
    end
  end
end

function Population:generate()
  local maxFitness = 0

  for i, indexes in ipairs(self.population) do
    local fitness = self:getFitness(indexes)
    if fitness > maxFitness then
      maxFitness = fitness
    end
  end

  local population = {}
  for i = 1, self.size do
    local indexes = self:select(maxFitness)
    local index1 = math.random(#indexes)
    local index2 = math.random(#indexes)
    local t = indexes[index1]
    indexes[index1] = indexes[index2]
    indexes[index2] = t
    table.insert(population, indexes)
  end

  self.population = population
  self.generation = self.generation + 1
end
