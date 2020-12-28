Ray = {}
Ray.__index = Ray

function Ray:create(x, y)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["direction"] = {
      ["x"] = 1,
      ["y"] = 0
    }
  }

  setmetatable(this, self)
  return this
end

function Ray:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(2)
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.line(0, 0, self.direction.x * 10, self.direction.y * 10)
  love.graphics.pop()
end
