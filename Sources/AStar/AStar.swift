// Copyright © 2020-2026 Brad Howes. All rights reserved.

import PriorityQueue

/**
 Contains the functionality for performing A\* path searches.

 There is only one public static method: ``AStar/find(oracle:start:end:)`` that sets up the environment and then performs the search.

 The `Oracle` generic parameter provides the `CostType` type that determines how costs are stored (Int, Float, etc.) and
 has a means to determine if a map location is usable and if so how costly it is to add to the path. There is also the
 `Location` associated type in the `Oracle` that defines a unique value for elements in the graph/map that is being
 searched. For a 2D grid, this would be a type like ``Coord2D``.
 */
public struct AStar<Oracle> where Oracle: GraphOracle {

    /// The type of the numeric cost used during path calculations.
  public typealias Cost = Oracle.Cost
  /// The type of the unique identifier associated with locations in the graph/map.
  public typealias Location = Oracle.Location
  /// The internal type used to track pending path nodes.
  typealias Node = PathNode<Location, Cost>


  /// Error types thrown by ``AStar/find(oracle:start:end:)``.
  public enum Failure: Error {
    /// The start location is not valid according to the oracle.
    case invalidStart
    /// The end location is not valid according to the oracle.
    case invalidEnd
    /// The start and end locations are the same.
    case sameStartEnd
  }

  /**
   Attempt to find the lowest-cost path between the start and end positions in a graph or map.

   - Parameter oracle: the oracle to to use for answering questions about the graph or map being investigated.
   - Parameter start: the starting position in the map.
   - Parameter end: the end (goal) position in the map.
   - Returns: an array of ``Position`` values that describes the lowest-cost path, or nil of none found.
   > Throws:
   >  - ``Failure/invalidStart`` -- if start is not a valid location.
   >  - ``Failure/invalidEnd`` -- if end is not valid location.
   >  - ``Failure/sameStartEnd`` -- if start and end are the same.
   */
  public static func find(
    oracle: Oracle,
    start: Location,
    end: Location
  ) throws -> [Position<Location, Cost>]? {
    guard start != end else { throw Failure.sameStartEnd }
    guard oracle.canVisit(location: start) else { throw Failure.invalidStart }
    guard oracle.canVisit(location: end) else { throw Failure.invalidEnd }

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
