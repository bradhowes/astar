// Copyright © 2020 Brad Howes. All rights reserved.
//

import Foundation

/**
 2D map coordinate.
 */
public struct Coord2D: Equatable, Hashable {
    let x: Int
    let y: Int
}

extension Coord2D {
    static func +(left: Coord2D, right: Coord2D) -> Coord2D { Coord2D(x: left.x + right.x, y: left.y + right.y) }
}
