// Copyright © 2026 Brad Howes. All rights reserved.

/**
 Accounting of the costs seen a given location. Used during A\* path finding to flag visited nodes and the best (lowest cost) path
 that has been there.
 */
internal struct VisitCost<Cost: NumericCost> {

  /// The cost of entering this location
  let locationCost: Cost
  /// The estimated cost of reaching the path destination from this location
  let estimatedCost: Cost
  /// The lowest path cost to visit the location
  let bestPathCost: Cost
  /// The current best know cost for this location
  var bestKnownCost: Cost { bestPathCost + locationCost }
  /// The `bestKnowCost` + `estimatedCost`
  var totalCost: Cost { bestKnownCost + estimatedCost }

  /**
   Create new instance with optional cost values.

   - parameter locationCost: the location cost
   - parameter estimatedCost: the estimated cost to reach the goal
   - parameter bestPathCost: the known best path cost so far
   */
  init(locationCost: Cost = .zero, estimatedCost: Cost = .zero, bestPathCost: Cost = .zero) {
    self.locationCost = locationCost
    self.estimatedCost = estimatedCost
    self.bestPathCost = bestPathCost
  }
}
