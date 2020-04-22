![Swift](https://github.com/bradhowes/AStar/workflows/Swift/badge.svg) [![License Badge]][License] [![Swift Badge]][Swift]

# AStar - an A* Library in Swift

The AStar library implements the classic A* path-finding algorithm. It uses a min priority queue for managing potential paths, ordered by each
path's known and estimated cost. The AStar class delegates map-related functionality to a `MapOracle` protocol to determine valid positions
as well as the cost of using a position. Example of a `MapOracle` can be found in the `AStarTests.swift` file.

The AStar API is very basic. There is just the static `find` method. Here is an example of it being used:

```
let mapData = MapData(data: [
    [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲],
    [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🌲, .🌲, .🗻, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🗻, .🗻, .🗻, .🗻, .🗻, .🌲],
    [.🌲, .🌲, .🗻, .🌲, .🌲, .🗻, .🌊, .🌊],
    [.🌲, .🌲, .🗻, .🌲, .🗻, .🗻, .🌲, .🌊],
    [.🌊, .🌲, .🗻, .🌲, .🌲, .🌲, .🗻, .🗻],
    [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🗻, .🌲]
])

let start = Coord2D(x: 4, y: 0)
let end = Coord2D(x: 4, y: 4)
func distanceToEnd(position: Coord2D) -> Int { abs(position.x - end.x) + abs(position.y - end.y) }
let path = AStar.find(mapOracle: mapOracle, considerDiagonalPaths: true,
                      heuristicCostCalulator: distancToEnd,
                      start: start, end: end)
```

Here is the visual representation of the map with the found path. The starting position appears as a red flag (🚩) and the end position is a 
checkered flag (🏁). The path in between these two points contains an adventurer (🏃).

```
let image = mapData.asString(path: path!)
print(image)
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🌲🌲🏃🌲🌲
🌲🌲🌲🌲🗻🌲🏃🌲
🌲🌲🗻🗻🗻🗻🗻🏃
🌲🌲🗻🌲🏁🗻🏃🌊
🌲🌲🗻🏃🗻🗻🏃🌊
🌊🌲🗻🌲🏃🏃🗻🗻
🌊🌲🌲🌲🌲🌲🗻🌲
```

You supply something that implements the `MapOracle` protocol like the `MapData` above. You decide if diagonal paths are acceptable,
and provide a way to estimate the cost of moving from a given point on the map to the end point (the _heuristic cost_). The start and end 
points complete the `find` request.

You get back an optional array of `Coord2D` values. If `nil` then there was no path to be found. Otherwise, the array will have the map
coordinates of the path that was found, starting at `start` and ending with `end`.

[Build Badge]: https://img.shields.io/github/workflow/status/bradhowes/AStar/Swift%20Package.svg "Build"
[Build]: https://github.com/bradhowes/AStar/actions

[License Badge]: https://img.shields.io/github/license/bradhowes/AStar.svg?color=yellow "MIT License"
[License]: https://github.com/bradhowes/AStar/blob/master/LICENSE.txt

[Swift Badge]: https://img.shields.io/badge/swift-5-orange.svg "Swift 5"
[Swift]: https://swift.org/blog/swift-5-released/
