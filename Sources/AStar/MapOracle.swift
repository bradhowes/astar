// Copyright © 2020 Brad Howes. All rights reserved.

/**
 Interface for what AStar needs from a map.
 */
public protocol MapOracle {

    /**
     Determine if the given position in the map can be part of a path.

     - parameter position: the location to check
     - returns: true if position is valid and not an obstacle
     */
    func isVisitable(position: Coord2D) -> Bool

    /**
     Determine the cost of the given position when added to the path. This is the real cost of the location, and not
     the heuristic cost .

     - parameter position: the location to check
     - returns: cost of the position
     */
    func cost<T: CostNumeric>(position: Coord2D) -> T
}
