// Copyright © 2020-2026 Brad Howes. All rights reserved.

/**
 Helper class that keeps track of the costs involved in reaching a given position in the map. Maintains a linked list
 of nodes that make up a path to the starting position. Should be able to get away with a `struct` with some retooling of
 the linked list tracking.
 */
internal struct PathNode<Location: Hashable, Cost: NumericCost> {

  /// Lcation of this node in a map
  let location: Location

  /// The cost to enter this location.
  let locationCost: Cost

  enum ParentLink {
    indirect case parent(PathNode<Location, Cost>)
  }

  /// The link to the previous node in the path of nodes
  private var parent: ParentLink?

  /**
   Known cost of the path to reach this node: ``parent.knownCost`` + ``positionCost``
   */
  private var knownCost: Cost = .zero

  /**
   Current total cost of this node: `knownCost` + last estimated cost.

   This can change when revisiting the node using a less-costly path.
   */
  private var totalCost: Cost = .zero

  /**
   Create a new root node (one without a parent) and no cost info.

   - parameter location: the location of the node in the map
   */
  init(location: Location) {
    self.location = location
    self.locationCost = .zero
  }

  /**
   Create a new node that extends the path of a parent Node

   - parameter location: the location of the node in the map
   - parameter cost: the cost of travelling into this node
   - parameter heuristicRemaining: the estimated cost travelling to the goal position from this position
   - parameter parent: the parent node representing the path to this node
   */
  init(location: Location, cost: Cost, estimatedCost: Cost, parent: PathNode) {
    self.location = location
    self.locationCost = cost
    self.parent = .parent(parent)
    knownCost = locationCost + parent.knownCost
    totalCost = knownCost + estimatedCost
  }

  /**
   Compare the current cost to this node with the estimated cost via another node, and if cheaper move the node to
   the new parent.

   - parameter estimatedCost: the estimated cost travelling to the goal position
   - parameter newParent: the Node to reparent if warranted.
   - returns: self if reparenting took place, otherwise nil.
   */
  func reparentIfCheaper(newParent: PathNode) -> PathNode? {
    if (newParent.knownCost + locationCost < knownCost) {
      return .init(
        location: location,
        cost: locationCost,
        estimatedCost: totalCost - knownCost,
        parent: newParent
      )
    }
    return nil
  }

  /**
   Obtain the path from the first Node in the chain to this one.

   - returns: collection of ``Position<CostType>`` values, ordered from start to end.
   */
  func path() -> [Position<Location, Cost>] {
    var paths: [Position<Location, Cost>] = []
    addPath(&paths)
    return paths
  }
}

extension PathNode {

  private func addPath(_ paths: inout [Position<Location, Cost>]) {
    if case let .parent(link) = parent {
      link.addPath(&paths)
    }
    paths.append(.init(location: location, locationCost: locationCost, runningCost: knownCost))
  }
}

extension PathNode {

  // For use in `PriorityQueue`
  static func < (left: PathNode, right: PathNode) -> Bool { left.totalCost < right.totalCost }
}
