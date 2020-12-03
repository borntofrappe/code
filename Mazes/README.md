# Mazes

Here you find a plethora of projects connected to mazes. Mazes with different algorithms, mazes with different shapes. The projects use _Lua_ as a programming language, _Love2D_ as a game engineto display the end result. However, the underlying concepts are not restricted to either utility. Immediately, I can think of using JavaScript and the Canvas API for a web-based alternative.

## Binary Tree

The algorithm works by visiting every cell of a grid once, and removing a gate east or north. Without creating any exit, the end result is that the maze has an uninterrupted corridor in the first row and in the last column.

In terms of code, I decided to implement the algorithms by describing the possible neighbors for each cell.

```lua
for column = 1, columns do
  for row = 1, rows do
    local neighbors = {}
  end
end
```

In the logic of the specific algorithm, each cell has at most two neighbors:

- to the top unless the cell is in the first row

  ```lua
  if row > 1 then
    table.insert(
      neighbors,
      {
        ["column"] = column,
        ["row"] = row - 1,
        ["gates"] = {"up", "down"}
      }
    )
  end
  ```

- to the right unless the cell is in the last column

  ```lua
  if column < columns then
    table.insert(
      neighbors,
      {
        ["column"] = column + 1,
        ["row"] = row,
        ["gates"] = {"right", "left"}
      }
    )
  end
  ```

With this setup, all that is necessary is to loop through the `cells` table, pick a neighbor from the available set and remove the connected gates.

## Sidewinder

The algorithm works similarly to the binary tree algorithm, which means each cell has still up to two neighbors, east or north. When selecting a neighbor north however, the connection is removed from a cell visited in the current row, and not immediately from the current cell.

In detail, traverse the grid left to right.

```lua
for row = self.rows, 1, -1 do
end
```

For each row, keep track of the visited cells in a dedicated data structure.

```lua
for row = self.rows, 1, -1 do
  local visited = {}
  for column = 1, self.columns do
    local cell = self.cells[column][row]
    table.insert(visited, cell)
  end
end
```

When the connection describes a neighbor above the current cell, pick a cell at random from the collection.

```lua
if connection.gates[1] == "up" then
  local visitedCell = visited[love.math.random(#visited)]
end
```

At this point, remove the gates from the appropriate pair.

```lua
local neighboringCell = self.cells[visitedCell.column][connection.row]

visitedCell.gates[connection.gates[1]] = nil
neighboringCell.gates[connection.gates[2]] = nil
```

Finally reset the value of the data structure so that the script locks the cell in place.

```lua
visited = {}
```

Outside of this instance, the connection describes a cell east, and the idea is to remove the gates; just like in the binary tree algorithm.

```lua
else
  local neighboringCell = self.cells[connection.column][connection.row]
  cell.gates[connection.gates[1]] = nil
  neighboringCell.gates[connection.gates[2]] = nil
end
```

## Simplified Dijsktra

This is a first attempt at describing the distance between a point and any other point in the grid. The demo waits for a key press on the enter key, and then proceeds to populate the grid with the distance from the selected cell.

Building on top of the code for the sidewinder algorithm, the demo adds a field to the `Cell` class to describe the cell's distance.

```lua
function Cell:new()
  this = {
    -- previous attributes
    ["distance"] = nil
  }
end
```

Initialized at `nil`, this value is eventually included through the `dijkstra` function, and printed in the center of the cell.

```lua
function Cell:render()
  -- draw gates

  if self.distance then
    love.graphics.printf(self.distance, self.x0, self.y0 + self.height / 2 - 4, self.width, "center")
  end
end
```

With this setup, the `dijkstra` function is created in `main.lua` with two parameters: `cell` and `distance`. The idea is to:

- mark the cell with the integer describing the distance

```lua
grid.cells[cell.column][cell.row].distance = distance
```

- look for available, neighboring cells

  To this end, the function creates a table describing the neighbors on all possible sides.

  ```lua
  local neighbors = {
    {
      ["gate"] = "up",
      ["dr"] = -1,
      ["dc"] = 0
    },
    {
      ["gate"] = "right",
      ["dr"] = 0,
      ["dc"] = 1
    },
    {
      ["gate"] = "down",
      ["dr"] = 1,
      ["dc"] = 0
    },
    {
      ["gate"] = "left",
      ["dr"] = 0,
      ["dc"] = -1
    }
  }
  ```

  Looping through the table, the idea is to then remove unavailable neighbors.

  Neighbors which exceed the grid.

  ```lua
  if
    not grid.cells[cell.column + neighbor.dc]
    or
    not grid.cells[cell.column + neighbor.dc][cell.row + neighbor.dr] then
    table.remove(neighbors, i)
  end
  ```

  Neighbors blocked by a gate.

  ```lua
  if cell.gates[neighbor.gate] then
    table.remove(neighbors, i)
  end
  ```

  Neighbors with a distance value, to avoid an infinite loop.

  ```lua
  if grid.cells[cell.column + neighbor.dc][cell.row + neighbor.dr].distance then
    table.remove(neighbors, i)
  end
  ```

- Tloop through the table of available neighbors, and call the `dijkstra` function once more. This time however, using the neighboring cell as a reference, and an incremented distance value.

  ```lua
  for i, neighbor in ipairs(neighbors) do
    local neighboringCell = grid.cells[cell.column + neighbor.dc][cell.row + neighbor.dr]

    dijkstra(neighboringCell, distance + 1)
  end
  ```

_Please note_: to illustrate the process of the algorithm, I decided to include a `Timer` utility and have each function call delayed by an arbitrary number of seconds.

## Aldous Broder

Aldous Broder produces a maze without bias, completely random. This comes at the price of a slower runtime however, as the algorithm visits individual cells more than once.

The idea is to have the `Cell` class with an additional field, detailing whether or not the cell has already been visited.

```lua
function Cell:new()
  this = {
    -- previous attributes
    ["visited"] = nil
  }
end
```

Initialized with `nil`, the value is set to `true` as the algorithm reaches the cell.

With this setup, the algorithm marks a cell as visited, and proceeds with a random walk.

```lua
local randomColumn = love.math.random(self.columns)
local randomRow = love.math.random(self.rows)
local cell = self.cells[randomColumn][randomRow]
cell.visited = true

while true
 -- random walk
 break
end
```

In the random walk, the idea is to pick a neighbor at random, and remove the connecting gate only if said neighbor has not been visited.

```lua
local neighboringCell = self.cells[connection.column][connection.row]
if not neighboringCell.visited then
  -- remove gate
end
```

If the neighbor has already been visited, however, the idea is to do nothing but continue the random walk from the neighboring cell.

```lua
cell = neighboringCell
```

This process continues until every cell has been visited. This is checked with a boolean, initialized at `true` and toggled to `false` as soon as the for loop finds an unvisited cell.

```lua
local allVisited = true
for column = 1, self.columns do
  for row = 1, self.rowss do
    if not self.cells[column][row].visited then
      allVisited = false
      break
    end
  end
end
```

Past the for loop, if `allVisited` is still `true`, the idea is to finally exit the while loop describing the random walk.

```lua
if allVisited then
  break
end
```

## Wilson

Instead of a purely random walk, such as the one described in Aldous Broder, Wilson's approach leverages a "loop-erased" random walk.

The idea is to:

- pick a cell at random and visit it

- pick an unvisited cell, and take note of its position

- from the still unvisited cell, start a random walk; in this walk

  - pick a neighbor at random, once again taking note of its position

  - if the neighbor is already noted in the random walk, start the walk anew

  - if the neighbor is visited, terminate the random walk

- visit every cell described in the random walk, and remove the gates connecting them together

- repeat the random walk until every cell has been visited

At first, there is only one visited cell, which means the random walk might take some time to remove any gate. As you progress and find visited cells, however it becomes easier and easier to find a path.

## Hunt and Kill

The algorithm is similar to Aldous-Broder, performing a random walk from cell to cell. However, the algorithm changes in the moment it finds a cell which has already been visited. In this instance, it performs a search, it hunts, for an unvisited cell with a visited neighbor.

In detailed steps:

- pick a cell and mark it as visited

- pick a neighbor at random

- if the neighbor has not already been visited, visit the cell and continue the random walk

- if the neighbor has already been visited, hunt for an unvisited cel

  - loop through the grid top to bottom, left to right

  - look for the first unvisited cell with visited neighbor(s)

  - connect the cell with one of its neighbors

  - resume the random walk from the cell

- end the random walk when every cell has been visited
