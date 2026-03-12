import Testing

@testable import AStar

@Suite
fileprivate struct AStarTests {

  let start = Coord2D(x: 4, y: 0)
  let end = Coord2D(x: 4, y: 4)

  static let data: [[Pattern]] = [
    [.🌊, .🌲, .🌲, .🌲, .🚩, .🌲, .🌲, .🌲],
    [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🌲, .🌲, .🗻, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🗻, .🗻, .🗻, .🗻, .🗻, .🌲],
    [.🌲, .🌲, .🗻, .🌲, .🏁, .🗻, .🌊, .🌊],
    [.🌲, .🌲, .🗻, .🌲, .🗻, .🌲, .🌲, .🌊],
    [.🌊, .🌲, .🗻, .🌲, .🌲, .🌲, .🗻, .🗻],
    [.🌊, .🌊, .🌲, .🌲, .🌲, .🌲, .🗻, .🌲]
  ]

  var mapDataIntCost = MapData<Int>(data: Self.data)
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

  var mapDataFloatCost = MapData<Float>(data: Self.data)
  var mapDataDoubleCost = MapData<Double>(data: Self.data)

  @Test
  func noDiagonals() throws {
    let path = try AStar<MapData<Int>>.find(
      oracle: mapDataIntCost,
      considerDiagonalPaths: false,
      start: start,
      end: end
    )
    #expect(path != nil)
    #expect(path?.count == 17)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 16)
    #expect(path?.map(\.locationCost).filter{ $0 == 0 }.count == 2)
    #expect(path?.map(\.locationCost).filter{ $0 == 1 }.count == 14)
    #expect(path?.map(\.locationCost).filter{ $0 == 2 }.count == 1)
    #expect(path?.map(\.locationCost).filter{ $0 == 99 }.count == 0)

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
  mutating func noDiagonalsPythagoreanDistance() throws {
    mapDataFloatCost.customDistance = { $0.distance(to: $1) }
    let path = try AStar<MapData<Float>>.find(
      oracle: mapDataFloatCost,
      considerDiagonalPaths: false,
      start: start,
      end: end
    )
    #expect(path != nil)
    #expect(path?.count == 17)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 16)
    #expect(path?.map(\.locationCost).filter{ $0 == 0 }.count == 2)
    #expect(path?.map(\.locationCost).filter{ $0 == 1 }.count == 14)
    #expect(path?.map(\.locationCost).filter{ $0 == 2 }.count == 1)
    #expect(path?.map(\.locationCost).filter{ $0 == 99 }.count == 0)

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
  mutating func noDiagonalsAlt() throws {
    mapDataIntCostAlt.customCost = {
      switch $0 {
      case .🌲, .🌊: return 1
      case .🗻: return 99
      default: return 0
      }
    }

    mapDataIntCostAlt.customDistance = { $0.distanceSquared(to: $1) }
    let path = try AStar<MapData<Int>>.find(
      oracle: mapDataIntCostAlt,
      considerDiagonalPaths: false,
      start: start,
      end: end
    )
    #expect(path != nil)
    #expect(path?.count == 17)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 15)
    #expect(path?.map(\.locationCost).filter{ $0 == 0 }.count == 2)
    #expect(path?.map(\.locationCost).filter{ $0 == 1 }.count == 15)
    #expect(path?.map(\.locationCost).filter{ $0 == 99 }.count == 0)

    let image = mapDataIntCostAlt.asString(path: path!)
    let expected = """
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🌲🏃🏃🏃🌲
🌲🌲🌲🌲🗻🌲🏃🏃
🌲🌲🗻🗻🗻🗻🗻🏃
🌲🌲🗻🏃🏁🗻🌊🏃
🌲🌲🗻🏃🗻🏃🏃🏃
🌊🌲🗻🏃🏃🏃🗻🗻
🌊🌊🌊🌲🌲🌲🗻🌲
"""
    #expect(image == expected)
  }

  @Test
  func noDiagonalsFloat() throws {
    let path = try AStar<MapData<Float>>.find(
      oracle: mapDataFloatCost,
      considerDiagonalPaths: false,
      start: start,
      end: end
    )
    #expect(path != nil)
    #expect(path?.count == 17)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 16.0)
    #expect(path?.map(\.locationCost).filter{ $0 == 0 }.count == 2)
    #expect(path?.map(\.locationCost).filter{ $0 == 1 }.count == 14)
    #expect(path?.map(\.locationCost).filter{ $0 == 2 }.count == 1)
    #expect(path?.map(\.locationCost).filter{ $0 == 99 }.count == 0)

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
      oracle: mapDataIntCost,
      considerDiagonalPaths: true,
      start: start,
      end: end
    )
    #expect(path != nil)
    #expect(path?.count == 7)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 6)
    #expect(path?.map(\.locationCost).filter{ $0 == 0 }.count == 2)
    #expect(path?.map(\.locationCost).filter{ $0 == 1 }.count == 4)
    #expect(path?.map(\.locationCost).filter{ $0 == 2 }.count == 1)
    #expect(path?.map(\.locationCost).filter{ $0 == 99 }.count == 0)

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
      oracle: mapDataFloatCost,
      considerDiagonalPaths: false,
      start: start,
      end: end
    )

    #expect(path != nil)
    #expect(path?.count == 5)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 4)
    #expect(path?.map(\.locationCost).filter{ $0 == 0 }.count == 1)
    #expect(path?.map(\.locationCost).filter{ $0 == 1 }.count == 4)
    #expect(path?.map(\.locationCost).filter{ $0 == 2 }.count == 0)
    #expect(path?.map(\.locationCost).filter{ $0 == 99 }.count == 0)

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
      oracle: mapDataIntCost,
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
        oracle: mapDataIntCost,
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
        oracle: mapDataIntCost,
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
        oracle: mapDataIntCost,
        considerDiagonalPaths: true,
        start: start,
        end: start
      )
    }
  }
}

fileprivate enum Pattern {
  case 🚩, 🌊, 🗻, 🌲, 🏁
}

fileprivate struct MapData<Cost: NumericCost>: GraphOracle {

  typealias Location = Coord2D

  private let map: [[Pattern]]
  private let bounds: (x: Range<Int>, y: Range<Int>)

  var customDistance: ((Coord2D, Coord2D) -> Cost)
  var customCost: (Pattern) -> Cost
  var customVisitable: (Pattern) -> Bool

  init(data: [[Pattern]]) {
    self.map = data
    self.bounds = (
      x: 0..<data.map(\.count).max()!,
      y: 0..<data.count
    )
    self.customDistance = { Cost.distance(from: $0, to: $1) }
    self.customCost = {
      switch $0 {
      case .🌲: return 1
      case .🌊: return 2
      default: return 0
      }
    }
    self.customVisitable = {
      switch $0 {
      case .🗻: return false
      default: return true
      }
    }
  }

  func asString(path: [Position<Location, Cost>]) -> String {
    let pathSet = Set(path.map(\.location))
    let start = path.first?.location
    let finish = path.last?.location
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
  func inBounds(position: Location) -> Bool {
    bounds.x.contains(position.x) && bounds.y.contains(position.y)
  }

  @inlinable
  func canVisit(location: Location) -> Bool {
    inBounds(position: location) && customVisitable(self[location])
  }

  @inlinable
  func cost(location: Location) -> Cost {
    customCost(self[location])
  }

  @inlinable
  func distance(from: Location, to: Location) -> Cost {
    customDistance(from, to)
  }

  func adjacentLocations(to location: Coord2D, diagonals: Bool) -> [Coord2D] {
    let offsets: [Offset2D] = (
      [.init(dx: -1, dy: 0), .init(dx: 0, dy: -1), .init(dx: 0, dy: 1), .init(dx: 1, dy: 0)] +
      (diagonals ? [.init(dx: -1, dy: -1), .init(dx: -1, dy: 1), .init(dx: 1, dy: -1), .init(dx: 1, dy: 1)] : [])
    )
    return offsets.map { location + $0 }.filter { canVisit(location: $0) }
  }
}
