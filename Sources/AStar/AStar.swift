// Copyright © 2020 Brad Howes. All rights reserved.

import PriorityQueue

/**
 Contains the functionality for performing A* path searches. There is only one public static method: `find`. It creates
 a new instance and then performs the search.

 The `OracleType` generic parameter provides the `CostType` type that determines how costs are stored (Int, Float, etc.)
 */
public final class AStar<OracleType> where OracleType: MapOracle {

    typealias NodeType = Node<OracleType.CostType>

    /// Function type that returns the heuristic cost for moving from a given position to an end goal (the method must
    /// have knowledge of the end goal)
    public typealias HeuristicCostCalculator = (Coord2D) -> OracleType.CostType

    /**
     Attempt to find the lowest-cost path from start to end positions of a given map.

     - parameter mapOracle: the map to to use for determining valid paths
     - parameter considerDiagonalPaths: if true, allow traveling diagonally from one position to another
     - parameter heuristicCostCalulator: function that returns the heuristic cost between a given position and the end
     goal
     - parameter start: the starting position in the map
     - parameter end: the end (goal) position in the map
     - returns: the array of positions that make up the lowest-cost path, or nil of none exists
     */
    public static func find(mapOracle: OracleType, considerDiagonalPaths: Bool,
                            heuristicCostCalulator: @escaping HeuristicCostCalculator,
                            start: Coord2D, end: Coord2D) -> [Coord2D]? {
        guard start != end else { return nil }
        guard mapOracle.isVisitable(position: start) else { return nil }
        guard mapOracle.isVisitable(position: end) else { return nil }
        return AStar(mapOracle: mapOracle, considerDiagonalPaths: considerDiagonalPaths,
                     heuristicCostCalulator: heuristicCostCalulator).find(start: start, end: end)
    }

    private let mapOracle: OracleType
    private let heuristicCostCalulator: HeuristicCostCalculator
    private let neighborOffsets: [Coord2D]
    private var openQueue = PriorityQueue<NodeType>()
    private var nodeCache = [Coord2D: NodeType]()

    private init(mapOracle: OracleType, considerDiagonalPaths: Bool,
                 heuristicCostCalulator: @escaping HeuristicCostCalculator) {
        self.mapOracle = mapOracle
        self.heuristicCostCalulator = heuristicCostCalulator

        var offsets = [Coord2D(x: -1, y: 0), Coord2D(x: 0, y: -1), Coord2D(x: 0, y: 1), Coord2D(x: 1, y: 0)]
        if considerDiagonalPaths {
            offsets += [Coord2D(x: -1, y: -1), Coord2D(x: -1, y: 1), Coord2D(x: 1, y: -1), Coord2D(x: 1, y: 1)]
        }

        self.neighborOffsets = offsets
    }
}

// MARK: - Private Implementation

extension AStar {

    private func find(start: Coord2D, end: Coord2D) -> [Coord2D]? {
        enqueue(position: start)
        while let node = openQueue.pop() {
            if node.position == end { return node.path() }
            node.lock()
            neighborOffsets.forEach { enqueue(position: node.position + $0, parent: node) }
        }

        return nil
    }

    private func enqueue(position: Coord2D) {
        let node = Node(position: position, heuristicRemaining: heuristicCostCalulator(position))
        nodeCache[position] = node
        openQueue.push(node)
    }

    private func enqueue(position: Coord2D, parent: NodeType) {
        guard mapOracle.isVisitable(position: position) else { return }
        guard let node = visit(position: position, parent: parent) else { return }
        openQueue.push(node)
    }

    private func visit(position: Coord2D, parent: NodeType) -> NodeType? {
        let heuristicRemaining = heuristicCostCalulator(position)
        if let node = nodeCache[position] {
            return node.reparentIfCheaper(heuristicRemaining: heuristicRemaining, newParent: parent)
        }

        let node = Node(position: position, cost: mapOracle.cost(position: position),
                        heuristicRemaining: heuristicRemaining, parent: parent)
        nodeCache[position] = node
        return node
    }
}
