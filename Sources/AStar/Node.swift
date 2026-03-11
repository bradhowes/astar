// Copyright © 2020-2026 Brad Howes. All rights reserved.

/**
 Helper class that keeps track of the costs involved in reaching a given position in the map. Maintains a linked list
 of nodes that make up a path to the starting position. Should be able to get away with a `struct` with some retooling of
 the linked list tracking.
 */
internal final class Node<CostType: CostNumeric> {

  /// Lcation of this node in a map
  let position: Coord2D

  /// How must did it cost to enter this location
  let positionCost: CostType

  /// The link to the previous node in the path of nodes
  private var parent: Node?

  /// If true, allow reparenting. This is allowed up until a node `lockDown` is invoked.
  private var canReparent: Bool = true

  /**
   This is the known cost of the path to reach this node. Anything beyond is a heuristic cost, up until this is
   locked down.
   */
  private var knownCost: CostType = .zero

  /// The total cost of this node: the known cost from the start + the estimated cost to the end
  private var totalCost: CostType = .zero

  /**
   Create a new root node (one without a parent) and no cost.

   - parameter position: the location of the node in the map
   */
  init(position: Coord2D) {
    self.position = position
    self.positionCost = .zero
  }

  /**
   Create a new node that extends the path of a parent Node

   - parameter position: the location of the node in the map
   - parameter cost: the cost of travelling into this node
   - parameter heuristicRemaining: the estimated cost travelling to the goal position from this position
   - parameter parent: the parent node representing the path to this node
   */
  init(position: Coord2D, cost: CostType, heuristicRemaining: CostType, parent: Node) {
    self.position = position
    self.positionCost = cost
    self.parent = parent
    updateCosts(parentKnownCost: parent.knownCost, heuristicCost: heuristicRemaining)
  }

  /**
   Compare the current cost to this node with the estimated cost via another node, and if cheaper move the node to
   the new parent.

   - parameter heuristicRemaining: the estimated cost travelling to the goal position
   - parameter newParent: the Node to reparent if warranted
   - returns: true if reparenting took place
   */
  func reparentIfCheaper(heuristicRemaining: CostType, newParent: Node) -> Node? {
    guard canReparent else { return nil }
    if (heuristicRemaining + positionCost + newParent.knownCost) < totalCost {
      self.parent = newParent
      updateCosts(parentKnownCost: newParent.knownCost, heuristicCost: heuristicRemaining)
      return self
    }
    return nil
  }

  /**
   Stop any further reparenting checks on this path.
   */
  func lockDown() { canReparent = false }

  /**
   Obtain the path from the first Node in the chain to this one.

   - returns: collection of ``Position<CostType>`` values, ordered from start to end.
   */
  func path() -> [Position<CostType>] {
    var paths: [Position<CostType>] = []
    addPath(&paths)
    return paths
  }
}

extension Node {

  private func addPath(_ paths: inout [Position<CostType>]) {
    if let parent {
      parent.addPath(&paths)
    }
    paths.append(.init(position: position, positionCost: positionCost, runningCost: knownCost))
  }

  private func updateCosts(parentKnownCost: CostType, heuristicCost: CostType) {
    knownCost = positionCost + parentKnownCost
    totalCost = knownCost + heuristicCost
  }
}

extension Node: Comparable {
  static func == (left: Node, right: Node) -> Bool { left.totalCost == right.totalCost }
  static func < (left: Node, right: Node) -> Bool { left.totalCost < right.totalCost }
}
