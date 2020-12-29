# 2D Ray Casting

The goal of this project is to recreate the demo introduced in [this challenge](https://thecodingtrain.com/CodingChallenges/145-2d-ray-casting.html) from [the coding train](https://thecodingtrain.com).

The topic is _ray casting_, whereby lines are projected from a point of reference against the surrounding environment. The lecturer implements a demo in the context of Processing, using the JavaScript language, but here I try to use two different stacks:

- Lua and Love2D

- JavaScript and the Canvas API

## Math

Regardless of the stack, the project includes the same formulas; the snippets are in Lua, but only because I used the language for the first demo.

### Unit Vector

For the ray, it is first necessary to find the coordinates describing [unit vector](https://en.wikipedia.org/wiki/Unit_vector); these are used to describe the segment from the point of reference.

In a first demo, the ray changes its direction according to the mouse cursor, and the vector is found by normalizing the distance between the point and the position of the mouse.

```lua
function Ray:lookAt(x, y)
  local dx = x - self.x
  local dy = y - self.y
  local norm = (dx ^ 2 + dy ^ 2) ^ 0.5

  self.direction.x = dx / norm
  self.direction.y = dy / norm
end
```

In the snippet the function receives the coordinates of the mouse cursor, computes the distance from the point of reference and finally the norm to the distances in the `x` and `y` dimension. The goal is to have `self.direction.x` and `self.direction.y` in the `[0, 1]` range.

In the final demo, the function becomes unnecessary, as the rays are finally initialized with an input angle.

```lua
function Ray:create(x, y, angle)
end
```

In this context, the unit vector is computed on the basis of the angle, using the cosine and sine functions.

```lua
local direction = {}
direction.x = math.cos(angle)
direction.y = math.sin(angle)
```

### Line Intersection

The relevant math is detailed in the [wiki page for line intersection](https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection), and proposed in detail in the cited video roughly at [minute 10](https://youtu.be/TOEi6T2mtHo?t=605).

The idea is to compute two values, `t` and `u`, on the basis of the coordinates of two segments, one describing a boundary and one describing the ray.

If the values fall in a prescribed range, it means that the segments do intersect, and the computed values are used to find the intersection's own coordinates.

### Distance

In the moment the demo includes more than a single boundary, the idea is to cast the ray to the closest wall. Here it is necessary to compute the distance between the point of reference and the intersection, on the basis of the different `x` and `y` values.

```lua
local distance = ((point.x - self.x) ^ 2 + (point.y - self.y) ^ 2) ^ 0.5
```
