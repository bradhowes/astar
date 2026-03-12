[![](https://github.com/bradhowes/astar/workflows/CI/badge.svg)]()
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbradhowes%2Fastar%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/bradhowes/astar)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbradhowes%2Fastar%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/bradhowes/astar)
[![License: MIT][mit]][license]

# AStar - an A* Library in Swift

The AStar library implements the classic A* path-finding algorithm. It uses a min priority queue for managing potential
paths, ordered by each path's known and estimated cost. The AStar class delegates map-related functionality to a
`GraphOracle` protocol to determine valid positions as well as the cost of using a position. Example of a `GraphOracle`
can be found in the `AStarTests.swift` file.

The AStar API is very basic. There is just the static `find` method. Here is an example of it being used:

```swift
let oracle = Oracle(data: [
    [.🌊, .🌲, .🌲, .🌲, .🚩, .🌲, .🌲, .🌲],
    [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🌲, .🌲, .🗻, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🗻, .🗻, .🗻, .🗻, .🗻, .🌲],
    [.🌲, .🌲, .🗻, .🌲, .🏁, .🗻, .🌊, .🌊],
    [.🌲, .🌲, .🗻, .🌲, .🗻, .🌲, .🌲, .🌊],
    [.🌊, .🌲, .🗻, .🌲, .🌲, .🌲, .🗻, .🗻],
    [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🗻, .🌲]
])

let start = Coord2D(x: 4, y: 0) // location of 🚩 above
let end = Coord2D(x: 4, y: 4)   // location of 🏁 above
let path = AStar.find(
  oracle: oracle, 
  start: start, 
  end: end
)
```

You supply an entity `oracle` that implements the `GraphOracle` protocol like the `Oracle` above. The oracle provides
information used by the A* algorithm to learn about the routes available from a location and the costs involved in
picking one. The start and end points indicate where to start the path and the goal to reach with the lowest possible
cost.

You get back an optional array of `Position` values. If `nil` then there was no path to be found. Otherwise, the array
will have the map coordinates and the costs of the path that was found, starting at `start` and ending with `end`.

Here is the visual representation of the map with the found path. The starting position appears as a red flag (🚩) and
the end position is a checkered flag (🏁). The path in between these two points contains an adventurer (🏃).

```swift
let image = mapData.asString(path: path!)
print(image)
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🌲🌲🏃🌲🌲
🌲🌲🌲🌲🗻🌲🏃🌲
🌲🌲🗻🗻🗻🗻🗻🏃
🌲🌲🗻🌲🏁🗻🏃🌊
🌲🌲🗻🌲🗻🏃🌲🌊
🌊🌲🗻🌲🌲🌲🗻🗻
🌊🌲🌲🌲🌲🌲🗻🌲
```

The map contains three different terrain elements, each with their own cost for travelling into their square:

* 🌲 tree (1)
* 🌊 water (2)
* 🗻 boulder (∞)

The algorithm minimizes the cost of traveling over terrain elements while at the same time trying to keep to the shortest path
to the goal. For comparison, here is what the algorithm found when constrained to not use diagonal moves:

```swift
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🏃🏃🌲🌲🌲
🌲🏃🏃🏃🗻🌲🌲🌲
🌲🏃🗻🗻🗻🗻🗻🌲
🌲🏃🗻🏃🏁🗻🌊🌊
🌲🏃🗻🏃🗻🌲🌲🌊
🌊🏃🗻🏃🌲🌲🗻🗻
🌊🏃🏃🏃🌲🌲🗻🌲

```

There is another path to the right that is also 16 moves, but it goes over two 🌊 positions which increases the total
cost of the trip by 2. Thus the algorithm chose the one shown above.

## Dependencies

This package relies on the [PriorityQueue](https://github.com/bradhowes/PriorityQueue) package for Swift that provides a
min/max ordering of items using a binary heap.

[mit]: https://img.shields.io/badge/License-MIT-A31F34.svg
[license]: https://opensource.org/licenses/MIT
