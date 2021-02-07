# Traveling Salesperson

The project follows the progress made in the repository devoted to the nature of code, and specifically the demos devoted to genetic algorithms. The goal is to develop a solution to the traveling salesperson problem, in order to find the shortest path connecting a series of points.

The demos are in Lua and Love2D, and follow the lessons learned from [The Coding Train YouTube channel](https://youtu.be/BAejnwN4Ccw)

## Points and paths

The first demo is useful to lay the foundations for the problem at hand. The script sets up a series of points in a table and creates a connection between the points in order. As the mouse is pressed on the window, the order of the item in the collection is altered swapping two elements at random and showing a different path.

## Lexicographic order

The project introduces an algorithm to solve a specific problem: arranging a series of letters in any possible configuration. This is ultimately useful to consider the possible paths connecting the points.

The algorithm is the topic of [a discussion on quora](https://www.quora.com/How-would-you-explain-an-algorithm-that-generates-permutations-using-lexicographic-ordering).

The demo itself creates the possible permutations and adds the matching string to a table, which is then displayed in the window.

## Lexicographic TS

The folder merges the code developed in the previous two demos, so that the program finds an answer to the traveling salesperson problem by considering each and every possibility. The solution is found, but the number of points is limited to avoid running the program for too long.

Instead of modifying the order of the `points` table, the script creates a separate collection for the indexes, and modifies the order of these values. `getPaths`, `getTotalDistance` are updated to consider the points in the order arranged by the indexes, at each iteration, so that eventually, the demo is able to consider every possible set of points.

_Please note:_ the script includes a function to compete the factorial, so that it is possible to describe how many permutations are left.

## Genetic algorithm TS

The problem of finding the shortest path is tackled with a genetic algorithm. This is achieved by having a population describe a series of indexes at random. With each iteration, the program considers the fitness of each member of the population, before creating a new population out of the best performing indexes.

With each iteration, the program also evaluates the total distance of the best fit, and updates the paths if said distance is less than the record one.

_Please note:_ as opposed to the lexicographic demo, which has an eventual stopping point as the script tries every permutation, the demo does not reach a conclusion. Eventually, the algorithm settles on a sequence of indexes, but the number of generations continues indefinitely.

## Crossover GA TS

The idea of the final demo is to build on top of the genetic algorithm and tweak how the new population is created.

Instead of modifying the selected collection swapping two indexes at random.

```lua
local indexes = self:select(maxFitness)
local i1 = math.random(#indexes)
local i2 = i1 > 1 and i1 - 1 or i1 + 1
swap(indexes, i1, i2)
table.insert(population, indexes)
```

The idea is to pick two collections, two parents so to speak, and create a new collection mixing, crossing the two together.

```lua
local p1 = self:select(maxFitness)
local p2 = self:select(maxFitness)
local indexes = self:crossOver(p1, p2)
table.insert(population, indexes)
```

The crossing algorithm is implemented by picking as follows:

- pick a sequence of indexes from the first parent

- loop through the indexes of the second parent, and complete the `indexes` table with the values of the second parent that are not already included with the first
