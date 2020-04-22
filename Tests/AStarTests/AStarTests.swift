import XCTest

@testable import AStar

final class AStarTests: XCTestCase {

    let end = Coord2D(x: 4, y: 4)
    func calcHeuristicCost(position: Coord2D) -> Int { abs(position.x - end.x) + abs(position.y - end.y) }
    let mapData = MapData<Int>(data: [
        [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲],
        [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲],
        [.🌲, .🌲, .🌲, .🌲, .🗻, .🌲, .🌲, .🌲],
        [.🌲, .🌲, .🗻, .🗻, .🗻, .🗻, .🗻, .🌲],
        [.🌲, .🌲, .🗻, .🌲, .🌲, .🗻, .🌊, .🌊],
        [.🌲, .🌲, .🗻, .🌲, .🗻, .🌲, .🌲, .🌊],
        [.🌊, .🌲, .🗻, .🌲, .🌲, .🌲, .🗻, .🗻],
        [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🗻, .🌲]
    ])

    func calcHeuristicCostFloat(position: Coord2D) -> Float { Float(abs(position.x - end.x) + abs(position.y - end.y)) }

    let mapDataFloatCost = MapData<Float>(data: [
        [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲],
        [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲],
        [.🌲, .🌲, .🌲, .🌲, .🗻, .🌲, .🌲, .🌲],
        [.🌲, .🌲, .🗻, .🗻, .🗻, .🗻, .🗻, .🌲],
        [.🌲, .🌲, .🗻, .🌲, .🌲, .🗻, .🌊, .🌊],
        [.🌲, .🌲, .🗻, .🌲, .🗻, .🌲, .🌲, .🌊],
        [.🌊, .🌲, .🗻, .🌲, .🌲, .🌲, .🗻, .🗻],
        [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🗻, .🌲]
    ])

    func testNoDiagonals() {
        let start = Coord2D(x: 4, y: 0)
        let path = AStar<Int>.find(mapOracle: mapData, considerDiagonalPaths: false,
                                   heuristicCostCalulator: calcHeuristicCost,
                                   start: start, end: end)
        XCTAssertNotNil(path)

        let image = mapData.asString(path: path!)
        let expected = """
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🏃🏃🌲🌲🌲
🌲🏃🏃🏃🗻🌲🌲🌲
🌲🏃🗻🗻🗻🗻🗻🌲
🌲🏃🗻🏃🏁🗻🌊🌊
🌲🏃🗻🏃🗻🌲🌲🌊
🌊🏃🗻🏃🌲🌲🗻🗻
🌊🏃🏃🏃🌲🌲🗻🌲

"""
        XCTAssertEqual(image, expected)
    }

    func testNoDiagonalsFloat() {
        let start = Coord2D(x: 4, y: 0)
        let path = AStar<Float>.find(mapOracle: mapDataFloatCost, considerDiagonalPaths: false,
                                     heuristicCostCalulator: calcHeuristicCostFloat,
                                     start: start, end: end)
        XCTAssertNotNil(path)

        let image = mapData.asString(path: path!)
        let expected = """
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🏃🏃🌲🌲🌲
🌲🏃🏃🏃🗻🌲🌲🌲
🌲🏃🗻🗻🗻🗻🗻🌲
🌲🏃🗻🏃🏁🗻🌊🌊
🌲🏃🗻🏃🗻🌲🌲🌊
🌊🏃🗻🏃🌲🌲🗻🗻
🌊🏃🏃🏃🌲🌲🗻🌲

"""
        XCTAssertEqual(image, expected)
    }


    func testDiagonals() {
        let start = Coord2D(x: 4, y: 0)
        let path = AStar.find(mapOracle: mapData, considerDiagonalPaths: true,
                              heuristicCostCalulator: calcHeuristicCost,
                              start: start, end: end)
        XCTAssertNotNil(path)

        let image = mapData.asString(path: path!)
        let expected = """
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🌲🌲🏃🌲🌲
🌲🌲🌲🌲🗻🌲🏃🌲
🌲🌲🗻🗻🗻🗻🗻🏃
🌲🌲🗻🌲🏁🗻🏃🌊
🌲🌲🗻🌲🗻🏃🌲🌊
🌊🌲🗻🌲🌲🌲🗻🗻
🌊🌲🌲🌲🌲🌲🗻🌲

"""
        XCTAssertEqual(image, expected)
    }

    func testNoPath() {
        let start = Coord2D(x: 7, y: 7)
        let path = AStar.find(mapOracle: mapData, considerDiagonalPaths: true,
                              heuristicCostCalulator: calcHeuristicCost,
                              start: start, end: end)
        XCTAssertNil(path)
    }

    func testInvalidStart() {
        let start = Coord2D(x: -1, y: 0)
        let path = AStar.find(mapOracle: mapData, considerDiagonalPaths: true,
                              heuristicCostCalulator: calcHeuristicCost,
                              start: start, end: end)
        XCTAssertNil(path)
    }

    func testInvalidEnd() {
        let start = Coord2D(x: 4, y: 0)
        let path = AStar.find(mapOracle: mapData, considerDiagonalPaths: true,
                              heuristicCostCalulator: calcHeuristicCost,
                              start: start, end: Coord2D(x: 4, y: 1000))
        XCTAssertNil(path)
    }

    func testSameStartEnd() {
        let start = Coord2D(x: 4, y: 0)
        let path = AStar.find(mapOracle: mapData, considerDiagonalPaths: true,
                              heuristicCostCalulator: calcHeuristicCost,
                              start: start, end: start)
        XCTAssertNil(path)
    }

    static var allTests = [
        ("testNoDiagonals", testNoDiagonals),
        ("testDiagonals", testDiagonals),
        ("testNoPath", testNoPath),
        ("testInvalidStart", testInvalidStart),
        ("testInvalidEnd", testInvalidEnd),
        ("testSameStartEnd", testSameStartEnd),
    ]
}

struct MapData<CostType: CostNumeric> {

    enum Pattern {
        case 🌊, 🗻, 🌲

        var visitable: Bool {
            switch self {
            case .🗻: return false
            case .🌲, .🌊: return true
            }
        }

        /// Cost of moving through this pattern
        var cost: CostType {
            switch self {
            case .🌲: return 1
            case .🌊: return 2
            case .🗻: return 3
            }
        }
    }

    private let data: [[Pattern]]
    private let max: (x: Int, y: Int)

    init(data: [[Pattern]]) {
        self.data = data
        self.max = (x: data.map { $0.count }.max()!, y: data.count)
    }

    func asString(path: [Coord2D]) -> String {
        let pathSet = Set(path)
        var text = ""
        for (y, line) in data.enumerated() {
            for (x, type) in line.enumerated() {
                let p = Coord2D(x: x, y: y)
                if p == path.first {
                    text += "🚩"
                }
                else if p == path.last {
                    text += "🏁"
                }
                else if pathSet.contains(p) {
                    text += "🏃"
                }
                else {
                    text += String(describing: type)
                }
            }
            text += "\n"
        }
        return text
    }

    private subscript(index: Coord2D) -> Pattern { data[index.y][index.x] }
}

extension MapData: MapOracle {

    func isVisitable(position: Coord2D) -> Bool {
        guard position.y >= 0 && position.y < max.y else { return false }
        let row = data[position.y]
        guard position.x >= 0 && position.x < row.count else { return false }
        return row[position.x].visitable
    }

    // FIXME: this looks so wrong.
    func cost<T>(position: Coord2D) -> T where T: CostNumeric { self[position].cost as! T }
}
