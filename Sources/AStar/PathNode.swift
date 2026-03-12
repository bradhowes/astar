// Copyright © 2020-2026 Brad Howes. All rights reserved.

/**
 Helper struct that keeps track of the costs involved in reaching a given position in the map. Maintains a linked list
 of nodes that make up a path to the starting position.
 */
internal struct PathNode<Location: Hashable, Cost: NumericCost> {

  /// Lcation of this node in a map
  let location: Location

  /// The costs associated with entering this location from a path.
  let visitCost: VisitCost<Cost>

  /// Known cost of the path to reach this node.
  var knownCost: Cost { visitCost.bestKnownCost }

  /// Current total cost of this node: `knownCost` + `visitCost.estimatedCost`. Although it can be calculated from other attributes,
  /// it is used for ordering (see `PathNode/<` below) so held here for performance.
  let totalCost: Cost

  private enum ParentLink {
    indirect case parent(PathNode<Location, Cost>)
  }

  /// The link to the previous node in the path of nodes
  private let parent: ParentLink?

  /**
   Create a new root node (one without a parent) and no cost info.

   - parameter location: the location of the node in the map
   */
  init(location: Location) {
    self.location = location
    self.visitCost = .init()
    self.totalCost = .zero
    self.parent = nil
  }

  /**
   Create a new node that extends the path of a parent Node

   - parameter location: the location of the node in the map
   - parameter cost: the cost of travelling into this node
   - parameter heuristicRemaining: the estimated cost travelling to the goal position from this position
   - parameter parent: the parent node representing the path to this node
   */
  init(location: Location, visitCost: VisitCost<Cost>, parent: PathNode) {
    self.location = location
    self.visitCost = visitCost
    self.parent = .parent(parent)
    self.totalCost = visitCost.totalCost
  }

  /**
   Obtain the path from the first Node in the chain to this one.

   - returns: collection of ``Position<Location, Cost>`` values, ordered from start to end.
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
    paths.append(.init(location: location, locationCost: visitCost.locationCost, runningCost: knownCost))
  }
}

extension PathNode {

  /**
   Define "less than" ordering between two `PathNode` instances. The `PathNode` does not have ``Orderable`` conformance, but
   this operation is given to a ``PriorityQueue`` used in the A\* processing so that the lowest-cost node is always available.

   - parameter left: the left-hand side of the comparison
   - parameter right: the right-hand side of the comparison
   - returns: true if left is less than right, otherwise false.
   */
  static func < (left: PathNode, right: PathNode) -> Bool { left.totalCost < right.totalCost }
}
