ParticleSystem = {}
ParticleSystem.__index = ParticleSystem

function ParticleSystem:new(string)
  local string = string or STRINGS.rocket

  local gridDimensions = string:find("\n") - 1
  local gridSize = WINDOW_SIZE - WINDOW_PADDING * 2
  local gridOffset = WINDOW_PADDING

  local cellSize = math.floor(gridSize / gridDimensions)
  local cellPadding = cellSize * 0.1
  local particleRadius = math.floor((cellSize - cellPadding * 2) / 2)

  string = string:gsub("\n", "")
  local particles = {}

  for i = 1, #string do
    if string:sub(i, i) == "o" then
      local column = ((i - 1) % gridDimensions) + 1
      local row = math.floor(i / gridDimensions) + 1

      local x = (column - 1) * cellSize + cellSize / 2 + gridOffset
      local y = (row - 1) * cellSize + cellSize / 2 + gridOffset

      local position =
        LVector:new(
        math.random(particleRadius, WINDOW_SIZE - particleRadius),
        math.random(particleRadius, WINDOW_SIZE - particleRadius)
      )
      local target = LVector:new(x, y)

      table.insert(particles, Particle:new(position, target, particleRadius))
    end
  end

  this = {
    ["particles"] = particles,
    ["mouse"] = LVector:new(-50, -50),
    ["gridDimensions"] = gridDimensions,
    ["gridOffset"] = gridOffset,
    ["cellSize"] = cellSize,
    ["particleRadius"] = particleRadius
  }

  setmetatable(this, self)
  return this
end

function ParticleSystem:update(dt)
  self.mouse = LVector:new(love.mouse:getPosition())

  for i, particle in pairs(self.particles) do
    particle:update(dt)
    particle:applyBehaviors(self.mouse)
  end
end

function ParticleSystem:updateParticles(string)
  local string = string:gsub("\n", "")
  local targets = {}
  for i = 1, #string do
    if string:sub(i, i) == "o" then
      local column = ((i - 1) % self.gridDimensions) + 1
      local row = math.floor(i / self.gridDimensions) + 1

      local x = (column - 1) * self.cellSize + self.cellSize / 2 + self.gridOffset
      local y = (row - 1) * self.cellSize + self.cellSize / 2 + self.gridOffset

      table.insert(targets, LVector:new(x, y))
    end
  end

  for i = 1, #targets do
    if i <= #self.particles then
      self.particles[i]:updateTarget(targets[i])
    else
      local position = LVector:copy(self.particles[#self.particles].position)
      table.insert(self.particles, Particle:new(position, targets[i], self.particleRadius))
    end
  end

  if #self.particles > #targets then
    for i = 1, #self.particles - #targets do
      table.remove(self.particles)
    end
  end
end

function ParticleSystem:render()
  love.graphics.setColor(1, 1, 1, 1)
  for i, particle in pairs(self.particles) do
    particle:render()
  end
end
