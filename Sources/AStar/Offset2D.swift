// Copyright © 2020-2026 Brad Howes. All rights reserved.
import Foundation

/**
 2D offset.
 */
public struct Offset2D {
  /// The change in X.
  public let dx: Int
  /// The change in Y.
  public let dy: Int

  /**
   Create new instance.

   - parameter dx: the change in X.
   - parameter dy: the change in Y.
   */
  public init(dx: Int, dy: Int) {
    self.dx = dx
    self.dy = dy
  }
}
