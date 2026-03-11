import Testing

@testable import AStar

@Suite
fileprivate struct AStarTests {

  let start = Coord2D(x: 4, y: 0)
  let end = Coord2D(x: 4, y: 4)

  var mapDataIntCost = MapData<Int>(data: [
    [.🌊, .🌲, .🌲, .🌲, .🚩, .🌲, .🌲, .🌲],
    [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🌲, .🌲, .🗻, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🗻, .🗻, .🗻, .🗻, .🗻, .🌲],
    [.🌲, .🌲, .🗻, .🌲, .🏁, .🗻, .🌊, .🌊],
    [.🌲, .🌲, .🗻, .🌲, .🗻, .🌲, .🌲, .🌊],
    [.🌊, .🌲, .🗻, .🌲, .🌲, .🌲, .🗻, .🗻],
    [.🌊, .🌊, .🌲, .🌲, .🌲, .🌲, .🗻, .🌲]
  ])

  var mapDataIntCostAlt = MapData<Int>(data: [
    [.🌊, .🌲, .🌲, .🌲, .🚩, .🌲, .🌲, .🌲],
    [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🌲, .🌲, .🗻, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🗻, .🗻, .🗻, .🗻, .🗻, .🌲],
    [.🌲, .🌲, .🗻, .🌲, .🏁, .🗻, .🌊, .🌊],
    [.🌲, .🌲, .🗻, .🌲, .🗻, .🌲, .🌲, .🌊],
    [.🌊, .🌲, .🗻, .🌲, .🌲, .🌲, .🗻, .🗻],
    [.🌊, .🌊, .🌊, .🌲, .🌲, .🌲, .🗻, .🌲] // extra cost to force alt route
  ])

  var mapDataFloatCost = MapData<Float>(data: [
    [.🌊, .🌲, .🌲, .🌲, .🚩, .🌲, .🌲, .🌲],
    [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🌲, .🌲, .🗻, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🗻, .🗻, .🗻, .🗻, .🗻, .🌲],
    [.🌲, .🌲, .🗻, .🌲, .🏁, .🗻, .🌊, .🌊],
    [.🌲, .🌲, .🗻, .🌲, .🗻, .🌲, .🌲, .🌊],
    [.🌊, .🌲, .🗻, .🌲, .🌲, .🌲, .🗻, .🗻],
    [.🌊, .🌊, .🌲, .🌲, .🌲, .🌲, .🗻, .🌲]
  ])

  @Test
  func noDiagonals() throws {
    let path = try AStar<MapData<Int>>.find(
      mapOracle: mapDataIntCost,
      considerDiagonalPaths: false,
      start: start,
      end: end
    )
    #expect(path != nil)
    #expect(path?.count == 17)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 16)
    #expect(path?.map(\.positionCost).filter{ $0 == 0 }.count == 2)
    #expect(path?.map(\.positionCost).filter{ $0 == 1 }.count == 14)
    #expect(path?.map(\.positionCost).filter{ $0 == 2 }.count == 1)
    #expect(path?.map(\.positionCost).filter{ $0 == 99 }.count == 0)

    let image = mapDataIntCost.asString(path: path!)
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
    #expect(image == expected)
  }

  @Test
  func noDiagonalsAlt() throws {
    let path = try AStar<MapData<Int>>.find(
      mapOracle: mapDataIntCostAlt,
      considerDiagonalPaths: false,
      start: start,
      end: end
    )
    #expect(path != nil)
    #expect(path?.count == 17)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 17)
    #expect(path?.map(\.positionCost).filter{ $0 == 0 }.count == 2)
    #expect(path?.map(\.positionCost).filter{ $0 == 1 }.count == 13)
    #expect(path?.map(\.positionCost).filter{ $0 == 2 }.count == 2)
    #expect(path?.map(\.positionCost).filter{ $0 == 99 }.count == 0)

    let image = mapDataIntCostAlt.asString(path: path!)
    let expected = """
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🌲🏃🏃🌲🌲
🌲🌲🌲🌲🗻🏃🏃🏃
🌲🌲🗻🗻🗻🗻🗻🏃
🌲🌲🗻🏃🏁🗻🏃🏃
🌲🌲🗻🏃🗻🏃🏃🌊
🌊🌲🗻🏃🏃🏃🗻🗻
🌊🌊🌊🌲🌲🌲🗻🌲
"""
    #expect(image == expected)
  }

  @Test
  func noDiagonalsFloat() throws {
    let path = try AStar<MapData<Float>>.find(
      mapOracle: mapDataFloatCost,
      considerDiagonalPaths: false,
      start: start,
      end: end
    )
    #expect(path != nil)
    #expect(path?.count == 17)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 16.0)
    #expect(path?.map(\.positionCost).filter{ $0 == 0 }.count == 2)
    #expect(path?.map(\.positionCost).filter{ $0 == 1 }.count == 14)
    #expect(path?.map(\.positionCost).filter{ $0 == 2 }.count == 1)
    #expect(path?.map(\.positionCost).filter{ $0 == 99 }.count == 0)

    let image = mapDataFloatCost.asString(path: path!)
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
    #expect(image == expected)
  }

  @Test
  func diagonals() throws {
    let path = try AStar.find(
      mapOracle: mapDataIntCost,
      considerDiagonalPaths: true,
      start: start,
      end: end
    )
    #expect(path != nil)
    #expect(path?.count == 7)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 6)
    #expect(path?.map(\.positionCost).filter{ $0 == 0 }.count == 2)
    #expect(path?.map(\.positionCost).filter{ $0 == 1 }.count == 4)
    #expect(path?.map(\.positionCost).filter{ $0 == 2 }.count == 1)
    #expect(path?.map(\.positionCost).filter{ $0 == 99 }.count == 0)

    let image = mapDataIntCost.asString(path: path!)
    let expected = """
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🌲🌲🏃🌲🌲
🌲🌲🌲🌲🗻🌲🏃🌲
🌲🌲🗻🗻🗻🗻🗻🏃
🌲🌲🗻🌲🏁🗻🏃🌊
🌲🌲🗻🌲🗻🏃🌲🌊
🌊🌲🗻🌲🌲🌲🗻🗻
🌊🌊🌲🌲🌲🌲🗻🌲
"""
    #expect(image == expected)
  }

  @Test
  mutating func sameCostAllVisitable() async throws {
    mapDataFloatCost.customVisitable = { _ in true }
    mapDataFloatCost.customCost = { _ in 1 }
    mapDataFloatCost.customDistance = { $0.distance(to: $1) }
    let path = try AStar.find(
      mapOracle: mapDataFloatCost,
      considerDiagonalPaths: false,
      start: start,
      end: end
    )

    #expect(path != nil)
    #expect(path?.count == 5)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 4)
    #expect(path?.map(\.positionCost).filter{ $0 == 0 }.count == 1)
    #expect(path?.map(\.positionCost).filter{ $0 == 1 }.count == 4)
    #expect(path?.map(\.positionCost).filter{ $0 == 2 }.count == 0)
    #expect(path?.map(\.positionCost).filter{ $0 == 99 }.count == 0)

    let image = mapDataFloatCost.asString(path: path!)
    let expected = """
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🌲🏃🌲🌲🌲
🌲🌲🌲🌲🏃🌲🌲🌲
🌲🌲🗻🗻🏃🗻🗻🌲
🌲🌲🗻🌲🏁🗻🌊🌊
🌲🌲🗻🌲🗻🌲🌲🌊
🌊🌲🗻🌲🌲🌲🗻🗻
🌊🌊🌲🌲🌲🌲🗻🌲
"""
    #expect(image == expected)
  }

  @Test
  func noPath() throws {
    let start = Coord2D(x: 7, y: 7)
    let path = try AStar.find(
      mapOracle: mapDataIntCost,
      considerDiagonalPaths: true,
      start: start,
      end: end
    )
    #expect(path == nil)
  }

  @Test
  func invalidStart() throws {
    let start = Coord2D(x: -1, y: 0)
    #expect(throws: AStarError.invalidStart) {
      try AStar.find(
        mapOracle: mapDataIntCost,
        considerDiagonalPaths: true,
        start: start,
        end: end
      )
    }
  }

  @Test
  func invalidEnd() throws {
    #expect(throws: AStarError.invalidEnd) {
      try AStar.find(
        mapOracle: mapDataIntCost,
        considerDiagonalPaths: true,
        start: start,
        end: Coord2D(x: 4, y: 1000)
      )
    }
  }

  @Test
  func sameStartEnd() throws {
    #expect(throws: AStarError.sameStartEnd) {
      try AStar.find(
        mapOracle: mapDataIntCost,
        considerDiagonalPaths: true,
        start: start,
        end: start
      )
    }
  }
}

fileprivate struct MapData<CostType: NumericCost>: MapOracle {

  enum Pattern {
    case 🚩, 🌊, 🗻, 🌲, 🏁

    var visitable: Bool {
      switch self {
      case .🗻: return false
      default: return true
      }
    }

    /// Cost of moving through this pattern
    var cost: CostType {
      switch self {
      case .🌲: return 1
      case .🌊: return 2
      default: return 0
      }
    }
  }

  private let map: [[Pattern]]
  private let bounds: (x: Range<Int>, y: Range<Int>)

  var customDistance: ((Coord2D, Coord2D) -> CostType)
  var customCost: (Pattern) -> CostType
  var customVisitable: (Pattern) -> Bool

  init(data: [[Pattern]]) {
    self.map = data
    self.bounds = (
      x: 0..<data.map(\.count).max()!,
      y: 0..<data.count
    )
    self.customDistance = { CostType.distance(from: $0, to: $1) }
    self.customCost = { $0.cost }
    self.customVisitable = { $0.visitable }
  }

  func asString(path: [Position<CostType>]) -> String {
    let pathSet = Set(path.map(\.position))
    let start = path.first?.position
    let finish = path.last?.position
    var text = ""
    for (y, line) in map.enumerated() {
      for (x, type) in line.enumerated() {
        let pos = Coord2D(x: x, y: y)
        switch pos {
        case start: text += "🚩"
        case finish: text += "🏁"
        default: text += pathSet.contains(pos) ? "🏃" : String(describing: type)
        }
      }
      text += "\n"
    }
    return String(text.dropLast())
  }

  private subscript(index: Coord2D) -> Pattern {
    map[index.y][index.x]
  }
}

extension MapData {

  @inlinable
  func inBounds(position: Coord2D) -> Bool {
    bounds.x.contains(position.x) && bounds.y.contains(position.y)
  }

  @inlinable
  func canVisit(position: Coord2D) -> Bool {
    inBounds(position: position) && customVisitable(self[position])
  }

  @inlinable
  func cost(position: Coord2D) -> CostType {
    customCost(self[position])
  }

  @inlinable
  func distance(from: Coord2D, to: Coord2D) -> CostType {
    customDistance(from, to)
  }
}
