Ray = {}
Ray.__index = Ray

function Ray:create(x, y, angle)
  -- find the unit vector consiedring the input angle
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
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setLineWidth(LINE_WIDTH_RAY)
  -- 10 is an arbitrary measure to show the direction of the ray
  love.graphics.line(self.x, self.y, self.x + self.direction.x * 10, self.y + self.direction.y * 10)
end

function Ray:lookAt(x, y)
  local dx = x - self.x
  local dy = y - self.y
  -- find the unit vector by normalizing the distance between cursor and point
  local norm = (dx ^ 2 + dy ^ 2) ^ 0.5

  self.direction.x = dx / norm
  self.direction.y = dy / norm
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

  if denominator == 0 then -- parallel lines
    return nil
  else
    local t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator
    local u = ((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denominator * -1
    if t > 0 and t < 1 and u > 0 then -- lines intersect
      return {
        ["x"] = x1 + t * (x2 - x1),
        ["y"] = y1 + t * (y2 - y1)
      }
    else -- lines do not intersect
      return nil
    end
  end
end
