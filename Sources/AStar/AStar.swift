// Copyright © 2020-2026 Brad Howes. All rights reserved.

import PriorityQueue

/**
 Contains the functionality for performing A\* path searches. There is only one public static method: `find` that sets up the
 environment and then performs the search.

 The `OracleType` generic parameter provides the `CostType` type that determines how costs are stored (Int, Float, etc.) and
 has a means to determine if a map location is visitable and how costly it is to do so.
 */
public struct AStar<OracleType> where OracleType: MapOracle {

  typealias NodeType = Node<OracleType.CostType>

  /**
   Function type that returns the heuristic cost for moving from a given position to an end goal (the method must have knowledge of
   the end goal).
   */
  public typealias HeuristicCostCalculator = (Coord2D) -> OracleType.CostType

  /**
   Attempt to find the lowest-cost path from start to end positions of a given map.

   - parameter mapOracle: the map to to use for determining valid paths
   - parameter considerDiagonalPaths: if true, allow traveling diagonally from one position to another
   - parameter heuristicCostCalulator: function that returns the heuristic cost between a given position and the end goal. This is
   separate from the `mapOracle` for convenience, but it could 
   - parameter start: the starting position in the map. If not valid, throws ``Failure.invalidStart``
   - parameter end: the end (goal) position in the map. If not valie, throws ``Failure.invalidEnd``. If same as ``start`` then
   throws ``Failure.sameStartEnd``.
   - returns: the array of positions that make up the lowest-cost path, or nil of none exists
   */
  public static func find(
    mapOracle: OracleType,
    considerDiagonalPaths: Bool,
    heuristicCostCalulator: @escaping HeuristicCostCalculator,
    start: Coord2D,
    end: Coord2D
  ) throws -> [Position<OracleType.CostType>]? {
    guard start != end else { throw AStarError.sameStartEnd }
    guard mapOracle.isVisitable(position: start) else { throw AStarError.invalidStart }
    guard mapOracle.isVisitable(position: end) else { throw AStarError.invalidEnd }

    let offsets = (
      [Coord2D(x: -1, y: 0), Coord2D(x: 0, y: -1), Coord2D(x: 0, y: 1), Coord2D(x: 1, y: 0)] +
      (considerDiagonalPaths ? [Coord2D(x: -1, y: -1), Coord2D(x: -1, y: 1), Coord2D(x: 1, y: -1), Coord2D(x: 1, y: 1)] : [])
    )

    let node: Node<OracleType.CostType> = .init(position: start)
    var pendingQueue = PriorityQueue<NodeType>(node)
    var visitedCache: [Coord2D: NodeType] = .init(dictionaryLiteral: (start, node))

    while let node = pendingQueue.pop() {
      if node.position == end {
        return node.path()
      }

      // This node has the best cost of all in the queue so lock it from futher changes.
      node.lockDown()

      offsets.forEach { offset in
        let position = node.position + offset
        if mapOracle.isVisitable(position: position) {
          let remaining = heuristicCostCalulator(position)
           if let cachedNode = visitedCache[position] {

            // Already visited node -- see if entering it would be cheaper now than it was before.
             if let newNode = cachedNode.reparentIfCheaper(heuristicRemaining: remaining, newParent: node) {

               // Yes, so need to revisit it.
               pendingQueue.push(newNode)
             }
          } else {

            // Add new node to check.
            let newNode: Node<OracleType.CostType> = .init(
              position: position,
              cost: mapOracle.cost(position: position),
              heuristicRemaining: remaining,
              parent: node
            )
            visitedCache[position] = newNode
            pendingQueue.push(newNode)
          }
        }
      }
    }

    return nil
  }
}

public enum AStarError: Error {
  case invalidStart
  case invalidEnd
  case sameStartEnd
}
