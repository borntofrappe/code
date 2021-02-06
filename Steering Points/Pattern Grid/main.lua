LVector = require "Lvector"
require "Grid"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
WINDOW_PADDING = 20

GRID_SIZE = WINDOW_WIDTH
CELL_DIMENSION = 20
CELL_SIZE = math.floor(GRID_SIZE / CELL_DIMENSION)
CELL_PADDING = CELL_SIZE * 0.25

CIRCLE_SEGMENTS = 20

UPDATE_SPEED = 20
VELOCITY_MIN = 10
VELOCITY_MAX = 20
VELOCITY_LIMIT = 20
STEERING_MULTIPLIER = 1
FRICTION_MULTIPLIER = 0.75
REPULSION_MULTIPLIER = 4

STRINGS = {
  ["rocket"] = [[xxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxooooooxx
xxxxxxxxxxooooooooox
xxxxxxxxxoooxxxxxoox
xxxxxxxoooxxxxxxxoox
xooooooooxxxxxxxxoox
xooxxoooxxoooxxxxoox
xxoxxooxxooxooxxxoox
xxooooxxxoxxxoxxooxx
xxxoooxxxoxxooxxooxx
xxxxoooxxooooxxooxxx
xxxoooooxxxxxxooxxxx
xxxooxoooxxxxoooxxxx
xxxoxxxoooxxoooxxxxx
xxxoxxxxoooooooxxxxx
xxxooxxoooooxxoxxxxx
xxxooooooxooxxoxxxxx
xxxxxxxxxxxooooxxxxx
xxxxxxxxxxxxxooxxxxx
xxxxxxxxxxxxxxxxxxxx]],
  ["codepen"] = [[xxxxxxxxxxxxxxxxxxxx
xxxxxxxxxooxxxxxxxxx
xxxxxxxooooooxxxxxxx
xxxxxoooxooxoooxxxxx
xxxoooxxxooxxxoooxxx
xooooxxxxooxxxxoooox
oooxxxxxxooxxxxxxooo
ooooxxxxxooxxxxxxooo
oooooxxxooooxxxooooo
ooxxoooooxxoooooxxoo
ooxxoooooxxoooooxxoo
oooooxxxooooxxxooooo
oooxxxxxxooxxxxxxooo
xoooxxxxxooxxxxxooox
xxoooxxxxooxxxxoooxx
xxxxoooxxooxxoooxxxx
xxxxxxooooooooxxxxxx
xxxxxxxooooooxxxxxxx
xxxxxxxxxooxxxxxxxxx
xxxxxxxxxxxxxxxxxxxx]],
  ["blog"] = [[xxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxx
xoooooooooooooxxxxxx
ooxxooxxxxxxxooxxxxx
oxxxxooxxxxxxoooxxxx
oooooooxxxxxxxooxxxx
oooooooxooooxxooxxxx
xxxxxooxxxxxxxooxxxx
xxxxxooxooxxxxooxxxx
xxxxxooxxxxxxxooxxxx
xxxxxooxoooxxxooxxxx
xxxxxooxxxxxxxooxxxx
xxxxxooxoxxxxxooxxxx
xxxxxooxxxoooooooooo
xxxxxooxxxoooooooooo
xxxxxooxxxoxxxxxxxoo
xxxxxooooooxxxxxxooo
xxxxxxooooooooooooox
xxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxx]],
  ["github"] = [[xxxxxxxxxxxxxxxxxxxx
xxxoooxxxooxxxoooxxx
xxooxooooooooooxooxx
xxooxxxxxxxxxxxxooxx
xxxooxxxxxxxxxxooxxx
xxxooxxxxxxxxxxooxxx
xxooxxxxxxxxxxxxooxx
xxooxxxxxxxxxxxxooxx
xxooxxxxxxxxxxxxooxx
xxooxxxxxxxxxxxxooxx
xxxooxxxxxxxxxxooxxx
xxxxoooooooooooooxxx
xxxxxoooooooooooxxxx
xxxxxoxxxxxxxxooxxxx
xxxxooxoxooxoxooxxxx
xxxxoxxoxooxoxxoxxxx
xxxxoxooxooxooxoxxxx
xxxooooooooooooooxxx
xxoooxxooxxooxxoooxx
xxxxxxxxxxxxxxxxxxxx]],
  ["freecodecamp"] = [[xxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxx
xxxooxxxxxxxxxxooxxx
xxooxxxooxxxxxxxooxx
xooxxxxxooxxxxxxxoox
xooxxxxxooxxxxxxxoox
xooxxxxxoooxxxxxxoox
ooxxxxxooooxoxxxxxoo
ooxxxxoooxoxooxxxxoo
ooxxxxooxxoxoooxxxoo
ooxxxooxxxoooooxxxoo
ooxxxooxxxooxooxxxoo
ooxxxooxxxxxxooxxxoo
ooxxxooxxxxxxooxxxoo
xooxxxooxxxxooxxxoox
xoooxxxooooooxxxooox
xxooxxxxooooxxxxooxx
xxxooxxxxxxxxxxooxxx
xxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxx]],
  ["twitter"] = [[xxxxxxxxxxxxxxxxx
xxxxxxxxxxxooooxxxxx
xxxxxxxxxxooooooxxxx
xoxxxxxxxooxxxxooxxx
xoooxxxxxooxxxxxoooo
xooooxxxxooxxxxxxoox
xooxoooooooxxxxxooxx
oxooxxooooxxxxxxooxx
oooooxxxxxxxxxxxooxx
ooooooxxxxxxxxxxooxx
xooxxxxxxxxxxxxxooxx
oooooxxxxxxxxxxxooxx
xoooxxxxxxxxxxxooxxx
xxoooxxxxxxxxxooxxxx
xxxooooxxxxxxoooxxxx
xoooooxxxxxxoooxxxxx
xxoooxxxxxxoooxxxxxx
xxxooooooooooxxxxxxx
xxxxxooooooxxxxxxxxx
xxxxxxxxxxxxxxxxxxxx]]
}

function love.load()
  love.window.setTitle("Steering points - Pattern Grid")
  love.window.setMode(WINDOW_WIDTH + WINDOW_PADDING * 2, WINDOW_HEIGHT + WINDOW_PADDING * 2)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  math.randomseed(os.time())

  grid = Grid:new()
  grid:setParticles(STRINGS.rocket)
end

function love.keypressed(key)
  if key == "r" then
    grid:setParticles(STRINGS.rocket)
  elseif key == "b" then
    grid:setParticles(STRINGS.blog)
  elseif key == "c" then
    grid:setParticles(STRINGS.codepen)
  elseif key == "f" then
    grid:setParticles(STRINGS.freecodecamp)
  elseif key == "g" then
    grid:setParticles(STRINGS.github)
  elseif key == "t" then
    grid:setParticles(STRINGS.twitter)
  end
end

function love.update(dt)
  grid:update(dt)
end

function love.draw()
  love.graphics.translate(WINDOW_PADDING, WINDOW_PADDING)
  grid:render()
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end
