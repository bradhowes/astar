// Copyright © 2020-2026 Brad Howes. All rights reserved.

// swiftlint:disable identifier_name
/**
 2D map coordinate.
 */
public struct Coord2D: Equatable, Hashable {
  public let x: Int
  public let y: Int
}

extension Coord2D {
  static func + (left: Coord2D, right: Coord2D) -> Coord2D { Coord2D(x: left.x + right.x, y: left.y + right.y) }
}
