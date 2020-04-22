import XCTest

@testable import AStar

final class Coord2DTests: XCTestCase {

    func testAddition() {

        let a = Coord2D(x: 1, y: 2)
        let b = Coord2D(x: 3, y: 5)
        let c = a + b

        XCTAssertEqual(c.x, a.x + b.x)
        XCTAssertEqual(c.y, a.y + b.y)
    }

    func testEquality() {
        let p1 = Coord2D(x: 10, y: 20)
        let p2 = Coord2D(x: 10, y: 20)
        XCTAssertEqual(p1, p2)
    }

    /**
     Test the hashing method, looking for collisions that from different X,Y values.
     */
    func testHashing() {
        var mp = [Coord2D: Coord2D]()
        let iterCount = 100_000
        for _ in 0..<iterCount {
            let x = Int(arc4random_uniform(100_000)) - 50_000
            let y = Int(arc4random_uniform(100_000)) - 50_000
            let p = Coord2D(x: Int(x), y: y)
            if let z = mp[p] {
                XCTAssertEqual(z, p)
            }
            else {
                mp[p] = p
            }
        }
    }

    static var allTests = [
        ("testAddition", testAddition),
        ("testEquality", testEquality),
        ("testHashing", testHashing)
    ]
}
