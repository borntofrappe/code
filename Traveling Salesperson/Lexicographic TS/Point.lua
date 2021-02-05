Point = {}
Point.__index = Point

function Point:new(x, y)
  local x = x or math.random(POINT_RADIUS, WINDOW_WIDTH - POINT_RADIUS)
  local y = y or math.random(POINT_RADIUS, WINDOW_HEIGHT - POINT_RADIUS)
  local position = LVector:new(x, y)

  local this = {
    ["position"] = position,
    ["r"] = POINT_RADIUS
  }

  setmetatable(this, self)
  return this
end

function Point:render()
  love.graphics.setColor(0.97, 0.97, 0.97, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end
