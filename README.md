# AStar - an A* Library in Swift

The AStar library implements the classic A* path-finding algorithm. It uses a MinPriorityQueue for managing potential paths, ordered by each
path's known and estimated cost. The AStar class delegates map-related functionality to a MapOracle protocol to determine valid positions as
well as the cost of using a position. Example of a MapOracle can be found in the AStarTests.swift file.

The AStar API is very basic:

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

You supply something that implements the `MapOracle` protocol like the `MapData` above. You decide if diagonal paths are acceptable,
and provide a way to estimate the cost of moving from any point on the map to the end point (the _heuristic cost_). The start and end points
complete the `find` request.

You get back an optional array of `Coord2D` values. If `nil` then there was no path to be found. Otherwise, the array will have the map
coordinates of the path that was found, starting at `start` and ending with `end`.
