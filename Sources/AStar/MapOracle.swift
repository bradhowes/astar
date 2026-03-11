// Copyright © 2020-2026 Brad Howes. All rights reserved.

/**
 Interface for what AStar needs from a map.
 */
public protocol MapOracle {
    associatedtype CostType: NumericCost

  /**
   Determine if the given position in the map can be part of a path.

   - parameter position: the location to check
   - returns: true if position is valid and not an obstacle
   */
  func canVisit(position: Coord2D) -> Bool

  /**
   Determine the cost of the given position when added to the path. This is the real cost of the location, and not
   the heuristic cost.

   - parameter position: the location to check
   - returns: cost of the position
   */
  func cost(position: Coord2D) -> CostType

  func distance(from: Coord2D, to: Coord2D) -> CostType
}

extension MapOracle {

  public func distance(from: Coord2D, to: Coord2D) -> CostType {
    CostType.distance(from: from, to: to)
  }
}
