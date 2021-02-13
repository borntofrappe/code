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

      local key = "c" .. column .. "r" .. row
      particles[key] = Particle:new(x, y, particleRadius)
    end
  end

  this = {
    ["particles"] = particles,
    ["mouse"] = LVector:new(-50, -50)
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

function ParticleSystem:render()
  love.graphics.setColor(1, 1, 1, 1)
  for i, particle in pairs(self.particles) do
    particle:render()
  end
end
