// Copyright © 2020-2026 Brad Howes. All rights reserved.

/**
 A representation of the cost of an A\* node, abstracted here to allow for integer and floating-point calculations. The
 A\* algorithm does not need to know the specifics of how costs are stored, only how to order them and how to create one
 with a zero value.
 */
public protocol NumericCost: SignedNumeric, Comparable {

  /**
   Calculate a "distance" value from one position to another for use as an estimated cost during shortest path construction.

   Usually this is some calculation that does not include any consideration for obstacles or actual costs incurred when
   moving into specific locations. It should generate the same value when the arguments are swapped.

   A common measure would be the magnitude of the line between the two locations -- the square root of the sum of the
   square of the components (x, y), also known as the Pythagorean distance. However, in the case of A\* path
   calculations, taking the square root is not necessary. Alternatively, one could also just take the sum of the
   absolute values of the coordinate changes. This is known as the taxicab distance or Manhattan distance or rectilinear
   distance. It too is sufficient to be used for A\* path calculations and it is the default implementation when
   `distance` is not provided by a conforming type.

   - Parameter from: the starting location.
   - Parameter to: the ending location.
   - Returns: an estimated cost.
   */
  static func distance(from: Coord2D, to: Coord2D) -> Self
}

extension Int: NumericCost {
  public static func distance(from: Coord2D, to: Coord2D) -> Self {
    from.taxiDistance(to: to)
  }
}

extension Float: NumericCost {
  public static func distance(from: Coord2D, to: Coord2D) -> Self {
    Self(from.taxiDistance(to: to))
  }
}

extension Double: NumericCost {
  public static func distance(from: Coord2D, to: Coord2D) -> Self {
    Self(from.taxiDistance(to: to))
  }
}
