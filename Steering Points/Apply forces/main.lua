LVector = require "Lvector"
require "Particle"
require "ParticleSystem"

STRING =
  [[xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxoooxxxoxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxoooooxooooxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxooooooooooxxxxxxxxoxxxxxoxxxxxxxxxxxxxxx
xxxxxxxxxxxxoooooooooooxxxxooxxxxxxxxooxxxxxxxxxxxxxx
xxxxxxxxxxoxxxoxoooooooxxxxoxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxooxxooooooooooxxxxxxxxxooxxxxooxxxxxxxxxxxxx
xxxxxxxxoooxoooxxxooooxxxxxxxxxxoxxxooooxxxooxxxxxxxx
xxxxxxxxoooooooxxxooooxxxxxxxxxxoxxoooooooxooxxxxxxxx
xxxoooxxxxooxoooxxoooxxxxxxxxoxxxxooooooooooooooooxxx
xxxooooooooooooxxxoooxxoxxxoooooxoooooooooooooooooxxx
xxxxooooooooooxxxxooxxooxoooooooooooooooooooooooxxxxx
xxxooooooooooxxoxxoxxxxxxoooxoooooooooooooooooooxxxxx
xxxooxxoooooooxooxxxxxxxoxxxoooooooooooooooooooxxxxxx
xxxxxxxxooooooooooxxxxxxxoooooooooooooooooooxooxxxxxx
xxxxxxxxooooooooooxxxxxxxoooooooooooooooooooxooxxxxxx
xxxxxxxxoooooooooxxxxxxxooxooxoxoooooooooooxoxoxxxxxx
xxxxxxxxxooooooxxxxxxxxxoxxoooooooooooooooxooxxxxxxxx
xxxxxxxxxxoooooxxxxxxxxoooooxxoxoooooooooxooxxxxxxxxx
xxxxxxxxxxxooxxooxxxxxoooooooooooxoooooooxxxxxxxxxxxx
xxxxxxxxxxxoooxxxxxxxxooooooooooxxxooxooxxxxxxxxxxxxx
xxxxxxxxxxxxxxooooxxxxxoooooooooxxxoxxxxxoxxxxxxxxxxx
xxxxxxxxxxxxxxoooooxxxxxxxooooooxxxxxooxoxxoxxxxxxxxx
xxxxxxxxxxxxxxooooooxxxxxxoooooxxxxxxxoooxxooxxxxxxxx
xxxxxxxxxxxxxxooooooxxxxxxooooxxxxxxxxxxxxooxxxxxxxxx
xxxxxxxxxxxxxxxooooxxxxxxxooooxoxxxxxxxxxooooxxxxxxxx
xxxxxxxxxxxxxxxooooxxxxxxxxooxxoxxxxxxxxooooooxxxxxxx
xxxxxxxxxxxxxxxoooxxxxxxxxxxoxxxxxxxxxxxooooooxxxxxxx
xxxxxxxxxxxxxxxoooxxxxxxxxxxxxxxxxxxxxxxoxxooxxxoxxxx
xxxxxxxxxxxxxxxooxxxxxxxxxxxxxxxxxoxxxxxxxxxxxxoxxxxx
xxxxxxxxxxxxxxxoxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx]]

CELL_SIZE = 15
PADDING = 2
RADIUS = CELL_SIZE / 2 - PADDING
FORCE_RADIUS = RADIUS / 4
MOUSE_RADIUS = RADIUS * 4
UPDATE_SPEED = 15
VELOCITY_MIN = 10
VELOCITY_MAX = 20
VELOCITY_LIMIT = 20
STEERING_MULTIPLIER = 1
FRICTION_MULTIPLIER = 0.8
REPULSION_MULTIPLIER = 4
NOISE_MULTIPLIER = 0.5

function love.load()
  local columns = STRING:find("\n") - 1
  local string, rows = STRING:gsub("\n", "")
  rows = rows + 1

  WINDOW_WIDTH = CELL_SIZE * columns
  WINDOW_HEIGHT = CELL_SIZE * rows

  love.window.setTitle("Steering points - Apply forces")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  local particles = {}
  for i = 1, #string do
    if string:sub(i, i) == "o" then
      local column = ((i - 1) % columns) + 1
      local row = math.floor(i / columns) + 1

      local x = (column - 1) * CELL_SIZE + CELL_SIZE / 2
      local y = (row - 1) * CELL_SIZE + CELL_SIZE / 2

      local key = "c" .. column .. "r" .. row
      particles[key] = Particle:new(x, y)
    end
  end

  particleSystem = ParticleSystem:new(particles)
end

function love.update(dt)
  particleSystem:update(dt)
end

function love.draw()
  particleSystem:render()
end
