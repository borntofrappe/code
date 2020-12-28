Particle = {}
Particle.__index = Particle

function Particle:create(x, y)
  local rays = {}
  for i = 0, 360, 5 do
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

function Particle:cast(boundaries)
  local pts = {}
  for i, ray in ipairs(self.rays) do
    local closestPoint = nil
    local closestDistance = nil
    for j, boundary in ipairs(boundaries) do
      local pt = ray:cast(boundary)
      if pt then
        local distance = ((pt.x - self.x) ^ 2 + (pt.y - self.y) ^ 2) ^ 0.5
        if not closestDistance or distance < closestDistance then
          closestDistance = distance
          closestPoint = {
            ["x"] = pt.x,
            ["y"] = pt.y
          }
        end
      end
    end
    if closestPoint then
      table.insert(pts, closestPoint)
    end
  end

  return pts
end

function Particle:move(x, y)
  self.x = x
  self.y = y

  for i, ray in ipairs(self.rays) do
    ray.x = x
    ray.y = y
  end
end
