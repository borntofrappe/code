# Maze Shapes

Here you find a few projects connected to mazes. Consider it a spiritual successor to _Maze Algorithms_, the project folder where I explored different algorithms with _Lua_ and _Love2D_.

## Grid

This demo introduces the shape already developed in the _Maze Algorithm_ folder. The grid is represented by a series of columns and rows, where each cell has up to four neighbors. The algorithms walks through the grid removing gates until every cell is visited.

## Grid Masking

The idea is to modify the regular shape by essentially "turning off" cells from the grid. A few cells are initialized to `nil`, and are removed from the possible neighbors. With this setup, all that the algorithm needs is picking a valid cell as a starting point.

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
