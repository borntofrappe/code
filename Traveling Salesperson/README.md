# Traveling Salesperson

The project follows the progress made in the repository devoted to the nature of code, and specifically the demos devoted to genetic algorithms. The goal is to develop a solution to the traveling salesperson problem, in order to find the shortest path connecting a series of points.

The demo is in Lua and Love2D, and follows the lessons learned from [The Coding Train YouTube channel](https://youtu.be/BAejnwN4Ccw)

## Points and paths

The first demo is useful to lay the foundations for the problem at hand. The script sets up a series of points in a table and creates a connection between the points in order. As the mouse is pressed on the window, the order of the item in the collection is altered swapping two elements at random and showing a different path.

## Lexicographic order

The project introduces an algorithm to solve a specific problem: arranging a series of letters in any possible configuration. This is ultimately useful to consider the possible paths connecting the points.

The algorithm is the topic of [a discussion on quora](https://www.quora.com/How-would-you-explain-an-algorithm-that-generates-permutations-using-lexicographic-ordering).

The demo itself creates the possible permutations and adds the matching string to a table, which is then displayed in the window.
