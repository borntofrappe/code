require "Particle"

Grid = {}
Grid.__index = Grid

function Grid:new(columns, rows)
  local particles = {}

  this = {
    ["columns"] = columns,
    ["rows"] = rows,
    ["particles"] = particles,
    ["showGridLines"] = false
  }

  setmetatable(this, self)
  return this
end

function Grid:toggleGridLines()
  self.showGridLines = not self.showGridLines
end

function Grid:makeKey(column, row)
  return "c" .. column .. "r" .. row
end

function Grid:hasParticle(column, row)
  return self.particles[self:makeKey(column, row)]
end

function Grid:addParticle(column, row, matchTarget)
  local x = (column - 1) * CELL_SIZE + CELL_SIZE / 2
  local y = (row - 1) * CELL_SIZE + CELL_SIZE / 2
  self.particles[self:makeKey(column, row)] = Particle:new(x, y, matchTarget)
end

function Grid:removeParticle(column, row)
  self.particles[self:makeKey(column, row)] = nil
end

function Grid:removeParticles()
  self.particles = {}
end

function Grid:update(dt)
  for i, particle in pairs(self.particles) do
    particle:update(dt)
    particle:applyBehaviors()
  end
end

function Grid:render()
  love.graphics.setColor(1, 1, 1)

  if self.showGridLines then
    love.graphics.setLineWidth(1)
    for column = 1, self.columns do
      love.graphics.line((column - 1) * CELL_SIZE, 0, (column - 1) * CELL_SIZE, WINDOW_HEIGHT)
    end
    for row = 1, self.rows do
      love.graphics.line(0, (row - 1) * CELL_SIZE, WINDOW_WIDTH, (row - 1) * CELL_SIZE)
    end
  end

  for i, particle in pairs(self.particles) do
    particle:render()
  end
end
