WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

function love.load()
  love.window.setTitle("Traveling salesperson - Lexicographic order")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.07, 0.07, 0.07)

  math.randomseed(os.time())

  values = {0, 1, 2, 3}
  permutations = {table.concat(values)}
  hasFinished = false
end

function swap(t, i, j)
  local temp = t[i]
  t[i] = t[j]
  t[j] = temp
end

function love.update(dt)
  if not hasFinished then
    -- largest index for which values[index] < values[index + 1]
    local index1 = 0

    for i = 1, #values - 1 do
      -- unnecessary to check if i > index1 since the counter variable is incremented with each iteration
      if values[i] < values[i + 1] then
        index1 = i
      end
    end

    if index1 == 0 then
      hasFinished = true
    else
      -- largest index for which values[index1] < values[index]
      local index2 = 0
      for i = 1, #values do
        if values[index1] < values[i] then
          index2 = i
        end
      end

      -- swap index1 and index2
      swap(values, index1, index2)

      -- reverse items from index1 to the end of the table
      local copy = {}
      for i = 1, #values do
        if i < index1 + 1 then
          table.insert(copy, values[i])
        else
          table.insert(copy, index1 + 1, values[i])
        end
      end

      values = copy
      table.insert(permutations, table.concat(values))
    end
  end
end

function love.draw()
  love.graphics.setColor(0.97, 0.97, 0.97, 1)
  love.graphics.print("Values " .. table.concat(values), 8, 8)
  love.graphics.print("Permutations", 8, 24)

  for i = 1, #permutations do
    love.graphics.print(permutations[i], 94, 24 + 16 * (i - 1))
  end
end
