// Copyright © 2020-2026 Brad Howes. All rights reserved.
import Foundation

/**
 2D map coordinate.
 */
public struct Coord2D: Equatable, Hashable {
  public let x: Int
  public let y: Int

  public init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }

  static var zero: Coord2D { .init(x: 0, y: 0) }
}

extension Coord2D {

  @inlinable
  static func + (left: Coord2D, right: Coord2D) -> Coord2D { Coord2D(x: left.x + right.x, y: left.y + right.y) }
}

extension Coord2D {

  @inlinable
  func distanceSquared(to: Coord2D) -> Int {
    let dx = to.x - x
    let dy = to.y - y
    return dx * dx + dy * dy
  }

  @inlinable
  func distance(to: Coord2D) -> Float {
    sqrt(Float(distanceSquared(to: to)))
  }
}
