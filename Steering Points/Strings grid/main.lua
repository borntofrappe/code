LVector = require "Lvector"
require "Particle"
require "ParticleSystem"

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
  ["twitter"] = [[xxxxxxxxxxxxxxxxxxxx
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

WINDOW_SIZE = 500
WINDOW_PADDING = 20

UPDATE_SPEED = 15
VELOCITY_MIN = 10
VELOCITY_MAX = 20
VELOCITY_LIMIT = 20
FORCE_RADIUS_MULTIPLIER = 0.25
MOUSE_RADIUS_MULTIPLIER = 4
STEERING_MULTIPLIER = 1
NOISE_MULTIPLIER = 0.5
FRICTION_MULTIPLIER = 0.8
REPULSION_MULTIPLIER = 4

function love.load()
  love.window.setTitle("Steering points - Strings grid")
  love.window.setMode(WINDOW_SIZE, WINDOW_SIZE)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  particleSystem = ParticleSystem:new()
end

function love.keypressed(key)
  if key == "r" then
    particleSystem = ParticleSystem:new(STRINGS.rocket)
  elseif key == "b" then
    particleSystem = ParticleSystem:new(STRINGS.blog)
  elseif key == "c" then
    particleSystem = ParticleSystem:new(STRINGS.codepen)
  elseif key == "f" then
    particleSystem = ParticleSystem:new(STRINGS.freecodecamp)
  elseif key == "g" then
    particleSystem = ParticleSystem:new(STRINGS.github)
  elseif key == "t" then
    particleSystem = ParticleSystem:new(STRINGS.twitter)
  end
end

function love.update(dt)
  particleSystem:update(dt)
end

function love.draw()
  particleSystem:render()
end
