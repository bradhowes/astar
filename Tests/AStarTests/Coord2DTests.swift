import Foundation
import Testing

@testable import AStar

@Suite
struct Coord2DTests {

  @Test
  func addition() {

    let a = Coord2D(x: 1, y: 2)
    let b = Coord2D(x: 3, y: 5)
    let c = a + b

    #expect(c.x == a.x + b.x)
    #expect(c.y == a.y + b.y)
  }

  @Test
  func equality() {
    let p1 = Coord2D(x: 10, y: 20)
    let p2 = Coord2D(x: 10, y: 20)
    #expect(p1 == p2)
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
      let x = Int(arc4random_uniform(100_000)) - 50_000
      let y = Int(arc4random_uniform(100_000)) - 50_000
      let p = Coord2D(x: Int(x), y: y)
      if let z = mp[p] {
        #expect(z == p)
      }
      else {
        mp[p] = p
      }
    }
  }
}
