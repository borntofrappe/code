Particle = {}
Particle.__index = Particle

function Particle:create(x, y)
  local rays = {}
  for i = 0, 360 do
    local angle = math.rad(i)
    table.insert(rays, Ray:create(x, y, angle))
  end

  this = {
    ["x"] = x,
    ["y"] = y,
    ["rays"] = rays
  }

  setmetatable(this, self)
  return this
end

function Particle:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", self.x, self.y, 6)
  -- for i, ray in ipairs(self.rays) do
  --   ray:render()
  -- end
end

function Particle:cast(boundary)
  local points = {}
  for i, ray in ipairs(self.rays) do
    local point = ray:cast(boundary)
    if point then
      table.insert(points, point)
    end
  end

  return points
end

function Particle:move(x, y)
  self.x = x
  self.y = y

  for i, ray in ipairs(self.rays) do
    ray.x = x
    ray.y = y
  end
end
