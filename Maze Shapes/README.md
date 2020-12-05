# Maze Shapes

Here you find a few projects connected to mazes of different shapes. Consider it a spiritual successor to _Maze Algorithms_, the project folder where I explored different algorithms with _Lua_ and _Love2D_.

## Regular Grid

This demo introduces the shape already developed in the _Maze Algorithm_ folder. The grid is represented by a series of columns and rows, where each cell has up to four neighbors. The algorithms walks through the grid removing gates until every cell is visited.

## [Grid Masking](https://repl.it/@borntofrappe/maze-grid-masking)

The idea is to modify the regular, rectangular shape by essentially "turning off" cells from the grid. A few cells are initialized to `nil`, and are removed from the possible neighbors. With this setup, all that the algorithm needs is picking a valid cell as a starting point.

The changes are introduced in `Grid.lua`. Here, the cells are included in the grid on the basis of a rough ASCII sketch.

```lua
local mask =
  [[xoooooooox
  ooooxxoooo
  oooxxxxooo
  ooooxxoooo
  xoooooooox
  xoooooooox
  ooooxxoooo
  oooxxxxooo
  ooooxxoooo
  xoooooooox
]]
```

The idea is to include cells for `o` characters, nil otherwise.

```lua
for column = 1, columns do
  for row = 1, rows do
    local index = column + (row - 1) * columns
    if mask:sub(index, index) == "o" then
      -- cell
    else
      -- nil
    end
  end
end
```

Once the cells are initialized, as mentioned earlier, it is necessary to also remove the `nil` cells from the `neighbors` table.

```lua
for column = 1, columns do
  for row = 1, rows do
    if cells[column][row] then
      -- remove nil neighbors
    end
  end
end
```

The recursive backtracker algorithm is able to pick valid neighbors, and continue its random walk until every non-nil cell is visited. The biggest change is how the first cell is selected. It is here essential to ensure that the algorithm picks a valid cell.

```lua
local randomCell = nil
while not randomCell do
  local randomColumn = love.math.random(self.columns)
  local randomRow = love.math.random(self.rows)
  randomCell = self.cells[randomColumn][randomRow]
end
```

## [Polar Grid](https://repl.it/@borntofrappe/maze-polar-grid)

The idea is to use polar coordinates and `love.graphics.arc` to draw cells as slices of circles with expanding radii. The function accepts an optional second argument for the arc type which embodies the desired result.

```lua
love.graphics.arc("line", "open", 0, 0, 20, 0, math.pi / 2)
```

Without specifying the type as `open`, the result is that the function draws two straight lines connecting the arc to the center of the grid.

Past this detail, the gates are drawn with four distinct instructions.

Consider this arbitrary structure as a reference.

![Polar Cell](https://github.com/borntofrappe/code/blob/master/Maze%20Shapes/polar-cell.svg)

The arc function describes the "up" and "down" variant, using the value described by the inner and outer radius.

```lua
if self.gates.up then
  love.graphics.arc("line", "open", 0, 0, self.outerRadius, self.angleStart, self.angleEnd)
end

if self.gates.down then
  love.graphics.arc("line", "open", 0, 0, self.innerRadius, self.angleStart, self.angleEnd)
end
```

The "left" and "right" gates are instead drawn with straight lines, connecting the space between the two arcs. The cartesian coordinates are computed for each cell using `math.cos` and `math.sin`. For instance and for right side, the coordinates consider the angle describing where the arc should end.

```lua
local x3 = innerRadius * math.cos(angleEnd)
local y3 = innerRadius * math.sin(angleEnd)
local x4 = outerRadius * math.cos(angleEnd)
local y4 = outerRadius * math.sin(angleEnd)
```

In `Grid.lua`, the structure of the grid is modified from one using columns and rows to one using rings and ring cells. The neighbors are included so that the grid essentially "wraps" around, so that each cell has always a neighbor on its left and right. For the right side, for instance, the variable `ringCell` is set to `1` to have the last cell in each ring refer to the first one.

```lua
table.insert(
  neighbors,
  {
    ["ring"] = ring,
    ["ringCell"] = ringCell + 1 > ringCells and 1 or ringCell + 1,
    ["gates"] = {"right", "left"}
  }
)
```

_Please note_: the rings have an equal number of slices, which leads to the maze having a rather uneven structure. This is fixed in a different demo implementing an adaptive grid. I decided to preserve this project as well to illustrate how the code changes from the regular, rectangular grid.

## [Polar Adaptive Grid](https://repl.it/@borntofrappe/maze-polar-adaptive-grid)

Building on top of the previous project, the demo tries to render a more realistic maze, one in which the cells are not excessively disparate in size. This is achieved by doubling the number of slices every other ring.

```lua
if ring % 2 == 0 then
  ringCells = ringCells * 2
end
```

This measure is then used not only to describe how many arcs should be in the specific ring, but also the angle of the mentioned arcs.

```lua
local angle = 2 * math.pi / ringCells

for ringCell = 1, ringCells do
  -- add slice
end
```

This takes care of populating a grid with more cells as the structure progresses outwards. It does not, however, solve the way the recursive backtracker algorithm works. Now the cells are allowed to have more than a single neighbor in the outer ring, and the `neighbors` table needs to be adjusted accordingly.

```lua
if ring % 2 ~= 0 then
  table.insert(
    neighbors,
    {
      ["ring"] = ring + 1,
      ["ringCell"] = ringCell - 1,
      ["gates"] = {"up", "down"}
    }
  )
end
```

The idea is to consider two neighbors in the outer ring. Since the the number of cells in ring changes however, it is necessary to double the counter variable.

```lua
if ring % 2 ~= 0 then
  ringCellNeighbor = ringCellNeighbor * 2 - 1
end
```

This takes care of the outer ring. However, going inwards, it is necessary to consider the instance in which the destination ring has half the number of arcs. In this instance, and conversely to the previous operation, the counter is halved.

```lua
 if ring % 2 == 0 then
  ringCellNeighbor = math.ceil(ringCellNeighbor / 2)
end
```

## [Hex Grid](https://repl.it/@borntofrappe/maze-hex-grid)

Similarly to the polar grid, what changes to create a hexagon grid is how each cell is rendered and which neighbor is assigned to the cell. In the regular grid there are up to four neighbors, in the polar adaptive grid up to five and here up to six. Consider the hexagon at the center of this basic illustration.

![Hexagon Grid](https://github.com/borntofrappe/code/blob/master/Maze%20Shapes/hexagon-grid.svg)

In this light, each cell is allowed to have six neighbors: north, north-east, south-east, south, south-west, north-west. The biggest challenge is to then ensure that the cells are attributed the correct neighbors. For instance, and considering the topmost cell in the illustration, this one has but three neighbors.

In `Grid.lua`, the hexagons are laid out as in the following structure.

![Hexagon Grid — Rows and Columns](https://github.com/borntofrappe/code/blob/master/Maze%20Shapes/hexagon-rows-columns.svg)

This structure changes the way cells access neighbors. Odd-numbered columns, for instance, have south-east neighbors in the same row (consider the cell `(1,1)`), while even-numbered columns need to consider the row directly below (consider the cell `(2,1)`).

The illustration should explain the different `if` statements used to populate the `neighbors` table.

In `Cell.lua` a regular hexagon is computed starting from the length of the side described by the `CELL_SIDE` constant. The math involved can be explained by this illustration.

![Hexagon Cell](https://github.com/borntofrappe/code/blob/master/Maze%20Shapes/hexagon-cell.svg)

The coordinates of the vertices are computed from the value of the segments `a` and `b`, and knowing the following relationships with the side.

```code
a = side / 2
b = side * math.sqrt(3) / 2
```

## [Triangle Grid](https://repl.it/@borntofrappe/maze-triangle-grid)

Exactly like the hexagon grid, what changes in the demo is the shape of a cell and its possible neighbors. Triangles are alternated as in the following visual.

![Triangle Row](https://github.com/borntofrappe/code/blob/master/Maze%20Shapes/triangle-rows-columns.svg)

This means the neighbors depend on whether or not the triangles are upright. If upright, the cell has a neighbor south, otherwise a neighbor north. The `if` statements consider this eventuality as well as the contours of the grid itself. For instance a neighbor north is only possible if the cell is not in the first row, and it is indeed upright.

```lua
if row > 1 then
  if not isUpright then
    table.insert(
      neighbors,
      {
        ["column"] = column,
        ["row"] = row - 1,
        ["gates"] = {"north", "south"}
      }
    )
  end
end
```

In `Cell.lua`, whether a triangle is upright or not changes the way the triangle is drawn. The vertices are drawn starting from the length of the triangle side, knowing that the width and height are computed as follows.

```code
width = side
height = side * math.sqrt(3) / 2
```

Consier this visual as a reference.

![Triangle Cell](https://github.com/borntofrappe/code/blob/master/Maze%20Shapes/triangle-cell.svg)
