// Copyright © 2020-2026 Brad Howes. All rights reserved.
import Foundation

/**
 2D map coordinate for a node in an A\* path that exists on an cartesian grid.
 */
public struct Coord2D: Equatable, Hashable {
  public let x: Int
  public let y: Int

  public init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }

  /// Instance that is at the cartesian origin.
  static var zero: Coord2D { .init(x: 0, y: 0) }
}

extension Coord2D {

  /**
   Create a new Coord2D by adding the a Coord2D with an Offset2D.
   - parameter left: the Coord2D to add
   - parameter right: the Offset2D to add
   - returns: new Coord2D value
   */
  @inlinable
  static func + (left: Coord2D, right: Offset2D) -> Coord2D { Coord2D(x: left.x + right.dx, y: left.y + right.dy) }
}

extension Coord2D {

  /**
   Calculate the distance to another location as the sum of the deltas in the X and Y coordinates.

   - parameter to: the other location to measure
   - returns: distance value
   */
  @inlinable
  public func taxiDistance(to: Coord2D) -> Int {
    (to.x - x) + (to.y - y)
  }

  /**
   Calculate the distance to another location as the sum of the squared deltas in the X and Y coordinates.

   - parameter to: the other location to measure
   - returns: distance value
   */
  @inlinable
  public func distanceSquared(to: Coord2D) -> Int {
    let dx = to.x - x
    let dy = to.y - y
    return dx * dx + dy * dy
  }


  /**
   Calculate the distance to another location as the squared root of the sum of the deltas in the X and Y coordinates, or
   Pythagorean distance.

   - parameter to: the other location to measure
   - returns: distance value
   */
  @inlinable
  public func distance(to: Coord2D) -> Float {
    sqrt(Float(distanceSquared(to: to)))
  }
}
