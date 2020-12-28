Ray = {}
Ray.__index = Ray

function Ray:create(x, y, angle)
  -- create vector from angle
  local direction = {}
  direction.x = math.cos(angle)
  direction.y = math.sin(angle)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["direction"] = direction
  }

  setmetatable(this, self)
  return this
end

function Ray:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(1)
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.line(0, 0, self.direction.x * 10, self.direction.y * 10)
  love.graphics.pop()
end

function Ray:lookAt(x, y)
  local vx = x - self.x
  local vy = y - self.y
  -- normalize vector
  local norm = (vx ^ 2 + vy ^ 2) ^ 0.5

  self.direction.x = vx / norm
  self.direction.y = vy / norm
end

function Ray:cast(boundary)
  local x1 = boundary.x1
  local y1 = boundary.y1
  local x2 = boundary.x2
  local y2 = boundary.y2

  local x3 = self.x
  local y3 = self.y
  local x4 = self.x + self.direction.x
  local y4 = self.y + self.direction.y

  local denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
  if denominator == 0 then
    return nil
  else
    local t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator
    local u = ((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3) * -1) / denominator
    if t > 0 and t < 1 and u > 0 then
      return {
        ["x"] = x1 + t * (x2 - x1),
        ["y"] = y1 + t * (y2 - y1)
      }
    else
      return nil
    end
  end
end
