// Copyright © 2020-2026 Brad Howes. All rights reserved.

/**
 Interface for what AStar needs from a graph/map to calculate the shortest path between two locations accounting for costs
 associated with traversals between graph nodes.

 There are two abstract types associated with the GraphOracle:

 - `Location` -- unique identifier for a node in the graph/map.
 - `Cost` -- a numerical expression of the cost associated with a graph.

 There are two costs being managed in A\* processing: a cost for entering a node in the graph, and a heuristic / estimated cost
 that indicates how close the current node is from the goal node. On 2D cartesian grid, this is usually a measure of distance
 between two points, so the closer the two points are the lower the estimated cost. Note that estimated costs only factor into the
 search aspect of the A\* path building; they do not appear in the final path results.
 */
public protocol GraphOracle {

  /// The type that will is used to uniquely identify a position in the graph/map managed by the oracle.
  associatedtype Location: Hashable
  /// The type that will hold the various costs calculated during the path search.
  associatedtype Cost: NumericCost

  /**
   Determine if the given location can be part of a path.

   - Parameter location: the location to check
   - Returns: `true` if so
   */
  func canVisit(location: Location) -> Bool

  /**
   Obtain a collection of positions next to the given one to be considered for adding to the optimal path. Note that only points
   that pass ``canVisit(location:)`` should be included.

   - Parameter location: the location to work with.
   - Returns: collection of `Location` values that are connected to the given location.
   */
  func adjacentLocations(to location: Location) -> [Location]

  /**
   Determine the cost of the given position when added to the path. This is the real cost of the location, not an estimated one.

   - Parameter location: the location to check
   - Returns: cost to enter the position
   */
  func cost(entering location: Location) -> Cost

  /**
   Determine an estimated cost for moving from one location to another. It should remain the same when called with the same
   coordinates, and it should not include any physical costs associated with specific locations between the coordinates. For a grid
   map, the fastest estimate would be to use ``Coord2D/taxiDistance(to:)``

   - Parameter from: the location to start at
   - Parameter to: the location to end at
   - Returns: a heuristic that represents the cost of moving from `from` to `to`.
   */
  func estimatedCost(from: Location, to: Location) -> Cost
}

extension GraphOracle where Location == Coord2D {

    /// Implementation of ``estimatedCost(from:to:)`` used when the `Location` associated type is ``Coord2D``.
  public func estimatedCost(from: Location, to: Location) -> Cost {
    Cost.distance(from: from, to: to)
  }
}
