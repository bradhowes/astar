// Copyright © 2020-2026 Brad Howes. All rights reserved.

/**
 Interface for what AStar needs from a map.
 */
public protocol GraphOracle {
  associatedtype Location: Hashable
  associatedtype Cost: NumericCost

  /**
   Determine if the given location can be part of a path.

   - parameter location: the location to check
   - returns: `true` if so
   */
  func canVisit(location: Location) -> Bool

  /**
   Obtain a collection of positions next to the given one to be considered for adding to the optimal path. Note that only points
   that pass `canVisit` should be included.
   */
  func adjacentLocations(to location: Location, diagonals: Bool) -> [Location]

  /**
   Determine the cost of the given position when added to the path. This is the real cost of the location, not an estimated one.

   - parameter location: the location to check
   - returns: cost to enter the position
   */
  func cost(location: Location) -> Cost

  /**
   Determine an estimated cost for moving from one location to another. It should remain the same when called with the same
   coordinates, and it should not include any physical costs associated with specific locations between the coordinates. For a grid
   map, the fastest estimate is to use ``Coord2D/taxiDistance``
   */
  func estimatedCost(from: Location, to: Location) -> Cost
}

extension GraphOracle where Location == Coord2D {

  public func estimatedCost(from: Location, to: Location) -> Cost {
    Cost.distance(from: from, to: to)
  }

  public func adjacentPositions(to location: Location, diagonals: Bool) -> [Location] {
    let offsets: [Offset2D] = (
      [.init(dx: -1, dy: 0), .init(dx: 0, dy: -1), .init(dx: 0, dy: 1), .init(dx: 1, dy: 0)] +
      (diagonals ? [.init(dx: -1, dy: -1), .init(dx: -1, dy: 1), .init(dx: 1, dy: -1), .init(dx: 1, dy: 1)] : [])
    )
    return offsets.map { location + $0 }.filter { canVisit(location: $0) }
  }
}
