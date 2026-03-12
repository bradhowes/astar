// Copyright © 2025 Brad Howes. All rights reserved.

/**
 A part of complete path that documents the location, how much it cost to enter, and the current
 running cost for the path up to this point.
 */
public struct Position<Location, Cost: NumericCost> {
  /// Lcation of this part of the path on a map
  public let location: Location
  /// How must did it cost to enter this location
  public let locationCost: Cost
  /// Running cost up to this point
  public let runningCost: Cost
}
