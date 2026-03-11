// Copyright © 2020-2026 Brad Howes. All rights reserved.

/**
 Interface for a type that will hold the cost of an AStar node. We need to be able to compare them and
 to represent a zero cost.
 */
public protocol NumericCost: SignedNumeric, Comparable {

  /**
   Calculate a "distance" value from one position to another.

   Usually this is some calculation that does not include any consideration for obstacles or actual costs incurred when
   moving into specific locations. It should generate the same value if the arguments are swapped.

   A common measure would be the magnitude of the line between the two locations: the square root of the sum of the square of the
   components (x, y), also known as the Pythagorean distance. However, in the case of A\* path calculations, taking the square root
   is not necessary. Alternatively, one could also just take the sum of the absolute values of the coordinate changes. This is
   known as the taxicab distance or Manhattan distance or rectilinear distance. It too is sufficient to be used for A\* path
   calculations.

   - parameter from: the starting location.
   - parameter to: the ending location.
   - returns: an estimated cost.
   */
  static func distance(from: Coord2D, to: Coord2D) -> Self
}

extension Int: NumericCost {
  public static func distance(from: Coord2D, to: Coord2D) -> Self {
    abs(to.x - from.x) + abs(to.y - from.y)
  }
}

extension Float: NumericCost {
  public static func distance(from: Coord2D, to: Coord2D) -> Self {
    Self(abs(to.x - from.x) + abs(to.y - from.y))
  }
}

extension Double: NumericCost {
  public static func distance(from: Coord2D, to: Coord2D) -> Self {
    Self(abs(to.x - from.x) + abs(to.y - from.y))
  }
}
