Path = {}
Path.__index = Path

function Path:new(x1, y1, x2, y2)
  local this = {
    ["x1"] = x1,
    ["y1"] = y1,
    ["x2"] = x2,
    ["y2"] = y2,
    ["lineWidth"] = LINE_WIDTH
  }

  setmetatable(this, self)
  return this
end

function Path:render()
  love.graphics.setColor(0.97, 0.97, 0.97, 1)
  love.graphics.setLineWidth(self.lineWidth)
  love.graphics.line(self.x1, self.y1, self.x2, self.y2)
end
