require "Particle"

Grid = {}
Grid.__index = Grid

function Grid:new()
  local particles = {}

  this = {
    ["dimension"] = CELL_DIMENSION,
    ["particles"] = particles
  }

  setmetatable(this, self)
  return this
end

function Grid:setParticles(string)
  local particles = {}

  local singleLineString = string:gsub("\n", "")
  for i = 1, #singleLineString do
    if singleLineString:sub(i, i) == "o" then
      local column = ((i - 1) % self.dimension) + 1
      local row = math.floor(i / self.dimension) + 1
      local key = "c" .. column .. "r" .. row
      local x = (column - 1) * CELL_SIZE + CELL_SIZE / 2
      local y = (row - 1) * CELL_SIZE + CELL_SIZE / 2

      particles[key] = Particle:new(x, y)
    end
  end

  self.particles = particles
end

function Grid:update(dt)
  for i, particle in pairs(self.particles) do
    particle:update(dt)
    particle:applyBehaviors()
  end
end

function Grid:render()
  love.graphics.setColor(1, 1, 1)

  for i, particle in pairs(self.particles) do
    particle:render()
  end
end
