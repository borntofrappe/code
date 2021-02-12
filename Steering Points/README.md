# Steering Points

The project is inspired by [a coding challenge](https://youtu.be/4hA7G3gup-4) from [The Coding Train](https://thecodingtrain.com/), and might actually involve a series of demos as I ultimately try to create a visual in which the particles move subject to forces and user (mouse) input.

## Create grid

The demo sets up a grid with a fixed number of columns and rows. This grid is modified with mouse and keyboard input by:

- clicking

  - left to add a point (if the cell is available)

  - right to remove a point (if the cell is populated)

- pressing

  - `e` to empty the grid

  - `g` to show the grid's lines

It is also possible to write a file locally by pressing:

- `t` to create a `.txt` file where every empty cell is represented by an `x` and every point by `o` characters

- `p` to create a `.png` image

_Please note:_ the `.txt` and `.png` files are created in the default path described by the [`love.system`](https://love2d.org/wiki/love.filesystem) module.

A special mention goes to the `makeKey` function. The idea is to have the `points` table populated only with the necessary points, not every possible column and row. In order to add and possibly remove these points, they are stored in the table with a key describing the position.

```lua
function Grid:makeKey(column, row)
  return "c" .. column .. "r" .. row
end
```

## Read grid

Starting from a sequence of `x`s and `o`s, much similar to one created with the previous demo, the goal is to populate a grid with points for every `o` character.

It is important to mention that the width and height of the window are set only after the script is able to discern the number of columns and rows.

For the number columns the position of the first newline character `\n` gives the index of the character separating the first and second row.

For the number of rows, instead, the number of newline characters `\n` points to one less than the actual value (since the last row ends with an `x` or `o`).

The demo removes the possibility to modify the grid of points, as well as save the visual in the `.txt` and `.png` formats. This is in order to focus on the reading logic.

## Apply forces

Building on top of the `Read grid` demo, the goal is to update the grid and points to have a particle system and particles instead. Each particle is attributed a position, velocity and acceleration. The acceleration is then modified to have the particles repelled by the mouse cursor, but always attracted to their original position.

The position of the mouse is updated in the particle system, to avoid computing the `x` and `y` coordinate in every instance of the particle entity.

```lua
function ParticleSystem:update(dt)
  self.mouse = LVector:new(love.mouse:getPosition())
end
```

The forces are then applied with a specific design:

- steer toward the target and apply friction when the particle is offset from the target itself

  ```lua
  FORCE_RADIUS = RADIUS / 4

  if distanceTargt > FORCE_RADIUS then
    -- steering and friction
  end
  ```

  The end result is that the particles jiggle around the desired coordinates. Without this threshold, the particles would eventually slow down to the precise `x` and `y` location.

  To avoid a perfectly symmetric jiggle, the steering force is also modified at random.

  ```lua
  local randomNoise = LVector:new(math.random() - 0.5, math.random() - 0.5)
  randomNoise:multiply(NOISE_MULTIPLIER)
  force:add(randomNoise)
  ```

- repel the mouse when the mouse itself is closer than a given range

  ```lua
  MOUSE_RADIUS = RADIUS * 4

  if distanceMouse < MOUSE_RADIUS then
    -- repel
  end
  ```

## Strings grid

Building on top of the project applying multiple forces, the idea is to change the configuration of the particles following a key press, and in order to draw the outline for different visuals.

| Key | Visual       |
| --- | ------------ |
| r   | rocket       |
| b   | blog         |
| c   | codepen      |
| f   | freecodecamp |
| g   | github       |
| t   | twitter      |

The particle system now receives a string, and populates the `particles` table to follow the `x` and `o` convention introduced earlier.

It is important to note that pressing a key does not update the target position of the particles. The particle system is instead re-initialized building an entire different collection of particles. The demo which follows try to implement this feature.

## Lua Particles

`particles` is immediately modified to include the particles in a sequence, not a table with key-value pairs. The key is indeed unnecessary, and has been unnecessary since the project which needed to add/remove points following a key press.

```lua
table.insert(particles, Particle:new(position, target, particleRadius))
```

The `Particle` entity is also modified to receive two vectors, describing the position and target. This is helpful in the moment new particles are positioned (at first) on top of existing ones.

```lua
function Particle:new(position, target, r)
end
```

With this structure, and in order to update the particle system to follow the instructions of a new string, the idea is to update the particles by modifying the `target` vector. If necessary then, the idea is to add/remove particles to consider the different number of `o` characters between strings.

## JavaScript Particles

The concept is recreated with the JavaScript language. The grid of particles is rendered through the Canvas API, animated with `requestAnimationFrame` and updated through mouse or keyboard input.
