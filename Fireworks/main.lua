require "Particle"
require "Firework"

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400

FIREWORKS = 8
RADIUS_FIREWORK = 2
VELOCITY_MIN = 380
VELOCITY_MAX = 580
GRAVITY = 450

PARTICLES = 100
RADIUS_PARTICLE = 1.5
VELOCITY_PARTICLE = 80
GRAVITY_PARTICLE = 240

COLOR_MIN = 50
COLOR_MAX = 255

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Fireworks")
  love.graphics.setBackgroundColor(0, 0, 0)

  fireworks = {}
  for i = 1, FIREWORKS do
    table.insert(fireworks, Firework:create())
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  for i = #fireworks, 1, -1 do
    local firework = fireworks[i]
    firework:update(dt)
    if firework.hasExpired then
      table.remove(fireworks, i)
      table.insert(fireworks, Firework:create())
    end
  end
end

function love.draw()
  for i, firework in ipairs(fireworks) do
    firework:render()
  end
end
