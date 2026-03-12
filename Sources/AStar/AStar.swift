// Copyright © 2020-2026 Brad Howes. All rights reserved.

import PriorityQueue

/**
 Contains the functionality for performing A\* path searches. There is only one public static method: `find` that sets up the
 environment and then performs the search.

 The `Oracle` generic parameter provides the `CostType` type that determines how costs are stored (Int, Float, etc.) and
 has a means to determine if a map location is visitable and how costly it is to do so. There is also `Location` associated type
 in the `Oracle` that defines a unique value for elements in the graph/map that is being search. For a 2D grid, this would be
 a type like ``Coor2D``.
 */
public struct AStar<Oracle> where Oracle: GraphOracle {

  public typealias Cost = Oracle.Cost
  public typealias Location = Oracle.Location
  typealias Node = PathNode<Location, Cost>

  /**
   Attempt to find the lowest-cost path from start to end positions of a given map.

   - parameter oracle: the oracle to to use for answering questions about the graph being investigated.
   - parameter start: the starting position in the map. If not valid, throws ``Failure.invalidStart``
   - parameter end: the end (goal) position in the map. If not valie, throws ``Failure.invalidEnd``. If same as ``start`` then
   throws ``Failure.sameStartEnd``.
   - returns: the array of positions that make up the lowest-cost path, or nil of none exists
   */
  public static func find(
    oracle: Oracle,
    start: Location,
    end: Location
  ) throws -> [Position<Location, Cost>]? {
    guard start != end else { throw AStarError.sameStartEnd }
    guard oracle.canVisit(location: start) else { throw AStarError.invalidStart }
    guard oracle.canVisit(location: end) else { throw AStarError.invalidEnd }

    let node: Node = .init(location: start)
    var pendingQueue = PriorityQueue<Node>(compare: { $0 < $1 }, node)
    var visitedCache: [Location: VisitCost<Cost>] = .init(dictionaryLiteral: (start, .init()))

    // TODO: monitor progress to detect looping due to improper oracle responses
    while let best = pendingQueue.pop() {
      if best.location == end {
        return best.path()
      }

      oracle.adjacentLocations(to: best.location).forEach { location in
        let visited = visitedCache[location]
        // swiftlint:disable:next force_unwrapping
        if visited == nil || best.knownCost < visited!.bestPathCost {
          let visitCost: VisitCost = .init(
            locationCost: visited?.locationCost ?? oracle.cost(entering: location),
            estimatedCost: visited?.estimatedCost ?? oracle.estimatedCost(from: location, to: end),
            bestPathCost: best.knownCost
          )
          visitedCache[location] = visitCost
          pendingQueue.push(
            .init(
              location: location,
              visitCost: visitCost,
              parent: best
            )
          )
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
