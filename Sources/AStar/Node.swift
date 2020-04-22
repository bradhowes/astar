import Foundation

/**
 Helper class that keeps track of the costs involved in reaching a given position in the map. Maintains a linked list of nodes that make up a path to the starting
 position.
 */
internal final class Node<CostType: CostNumeric> {

    let position: Coord2D

    /// The total cost of this node: the known cost from the start + the estimated cost to the end
    private(set) var totalCost: CostType = 0

    private let positionCost: CostType
    private var parent: Node?
    private var canReparent: Bool = true
    private var knownCost: CostType = 0

    /**
     Create a new root node (one without a parent)

     - parameter position: the location of the node in the map
     - parameter heuristicRemaining: the estimated cost travelling to the goal position
     */
    init(position: Coord2D, heuristicRemaining: CostType) {
        self.position = position
        self.positionCost = 0
    }

    /**
     Create a new node that extends the path of a parent Node

     - parameter position: the location of the node in the map
     - parameter cost: the cost of travelling into this node
     - parameter heuristicRemaining: the estimated cost travelling to the goal position
     - parameter parent: the parent node representing the path to this node
     */
    init(position: Coord2D, cost: CostType, heuristicRemaining: CostType, parent: Node) {
        self.position = position
        self.positionCost = cost
        self.parent = parent
        setCosts(parentKnownCost: parent.knownCost, heuristicCost: heuristicRemaining)
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
            setCosts(parentKnownCost: newParent.knownCost, heuristicCost: heuristicRemaining)
            return self
        }
        return nil
    }

    /**
     Stop any further reparenting checks on this path.
     */
    func lock() { canReparent = false }

    /**
     Obtain the path from the first Node in the chain to this one.

     - returns: array of Coord2D values
     */
    func path() -> [Coord2D] {
        guard let parent = self.parent else { return [position] }
        return parent.path() + [position]
    }
}

extension Node {
    private func setCosts(parentKnownCost: CostType, heuristicCost: CostType) {
        knownCost = positionCost + parentKnownCost
        totalCost = knownCost + heuristicCost
    }
}

extension Node: Comparable {
    static func ==(left: Node, right: Node) -> Bool { left.totalCost == right.totalCost }
    static func  <(left: Node, right: Node) -> Bool { left.totalCost < right.totalCost }
}
