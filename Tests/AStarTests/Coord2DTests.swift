import Foundation
import Testing

@testable import AStar

@Suite
struct Coord2DTests {

  @Test
  func addition() {

    let x = Coord2D(x: 1, y: 2)
    let y = Offset2D(dx: 3, dy: 5)
    let z = x + y

    #expect(z.x == x.x + y.dx)
    #expect(z.y == x.y + y.dy)
  }

  @Test
  func equality() {
    let x = Coord2D(x: 10, y: 20)
    let y = Coord2D(x: 10, y: 20)
    #expect(x == y)
    #expect(Coord2D.zero == .init(x: 0, y: 0))
  }

  /**
   Test the hashing method, looking for collisions that from different X,Y values.
   */
  @Test
  func hashing() {
    var mp = [Coord2D: Coord2D]()
    let iterCount = 100_000
    for _ in 0..<iterCount {
      let x = Int.random(in: 0...100_000) - 50_000
      let y = Int.random(in: 0...100_000) - 50_000
      let z = Coord2D(x: Int(x), y: y)
      if let tmp = mp[z] {
        #expect(tmp == z)
      } else {
        mp[z] = z
      }
    }
  }

  @Test
  func taxiDistance() {
    #expect(Coord2D(x: 1, y: 2).taxiDistance(to: Coord2D(x: 3, y: 5)) == 2 + 3)
  }

  @Test
  func distanceSquared() {
    #expect(Coord2D(x: 1, y: 2).distanceSquared(to: Coord2D(x: 3, y: 5)) == 4 + 9)
  }

  @Test
  func distance() {
    #expect(Coord2D(x: 1, y: 2).distance(to: Coord2D(x: 3, y: 5)) == sqrt(4 + 9))
  }
}
