// Copyright © 2020-2026 Brad Howes. All rights reserved.

import PriorityQueue

/**
 Contains the functionality for performing A\* path searches. There is only one public static method: `find` that sets up the
 environment and then performs the search.

 The `OracleType` generic parameter provides the `CostType` type that determines how costs are stored (Int, Float, etc.) and
 has a means to determine if a map location is visitable and how costly it is to do so.
 */
public struct AStar<Oracle> where Oracle: GraphOracle {

  public typealias Cost = Oracle.Cost
  public typealias Location = Oracle.Location
  typealias Node = PathNode<Location, Cost>

  /**
   Attempt to find the lowest-cost path from start to end positions of a given map.

   - parameter mapOracle: the map to to use for determining valid paths
   - parameter considerDiagonalPaths: if true, allow traveling diagonally from one position to another
   - parameter estimatedCostCalulator: function that returns the heuristic cost between a given position and the end goal. This is
   separate from the `mapOracle` for convenience.
   - parameter start: the starting position in the map. If not valid, throws ``Failure.invalidStart``
   - parameter end: the end (goal) position in the map. If not valie, throws ``Failure.invalidEnd``. If same as ``start`` then
   throws ``Failure.sameStartEnd``.
   - returns: the array of positions that make up the lowest-cost path, or nil of none exists
   */
  public static func find(
    oracle: Oracle,
    considerDiagonalPaths: Bool,
    start: Location,
    end: Location
  ) throws -> [Position<Location, Cost>]? {
    guard start != end else { throw AStarError.sameStartEnd }
    guard oracle.canVisit(location: start) else { throw AStarError.invalidStart }
    guard oracle.canVisit(location: end) else { throw AStarError.invalidEnd }

    let node: Node = .init(location: start)
    var pendingQueue = PriorityQueue<Node>(compare: { $0 < $1 }, node)
    var visitedCache: [Location: Node] = .init(dictionaryLiteral: (start, .init(location: start)))

    while let best = pendingQueue.pop() {
      if best.location == end {
        return best.path()
      }

      oracle.adjacentLocations(to: best.location, diagonals: considerDiagonalPaths).forEach { location in
        let pending: Node?
        if let visited = visitedCache[location] {

          // Already visited location -- see if entering it would be cheaper now than it was before.
          // Here, estimatedCost is the same as before; the only difference would be if the parent node cost is lower now.
          pending = visited.reparentIfCheaper(newParent: best)
        } else {

          // Add new node to check.
          pending = .init(
            location: location,
            cost: oracle.cost(location: location),
            estimatedCost: oracle.estimatedCost(from: location, to: end),
            parent: best
          )
        }

        if let pending {
          visitedCache[location] = pending
          pendingQueue.push(pending)
        }
      }
    }

    return nil
  }
}

public enum AStarError: Error {
  case invalidStart
  case invalidEnd
  case sameStartEnd
}
