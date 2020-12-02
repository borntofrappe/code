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
