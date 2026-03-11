// Copyright © 2025 Brad Howes. All rights reserved.

/**
 A part of complete path that documents the location, how much it cost to enter, and the current
 running cost for the path up to this point.
 */
public struct Position<CostType: CostNumeric> {
  /// Lcation of this part of the path on a map
  public let position: Coord2D
  /// How must did it cost to enter this location
  public let positionCost: CostType
  /// Running cost up to this point
  public let runningCost: CostType
}
