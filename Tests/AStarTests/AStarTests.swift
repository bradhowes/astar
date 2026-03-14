import Testing

@testable import AStar

@Suite
private struct AStarTests {

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

  static let expectedLeft = """
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🏃🏃🌲🌲🌲
🌲🏃🏃🏃🗻🌲🌲🌲
🌲🏃🗻🗻🗻🗻🗻🌲
🌲🏃🗻🏃🏁🗻🌊🌊
🌲🏃🗻🏃🗻🌲🌲🌊
🌊🏃🗻🏃🌲🌲🗻🗻
🌊🏃🏃🏃🌲🌲🗻🌲
"""

  static let expectedRight = """
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🌲🏃🏃🏃🌲
🌲🌲🌲🌲🗻🌲🏃🏃
🌲🌲🗻🗻🗻🗻🗻🏃
🌲🌲🗻🏃🏁🗻🌊🏃
🌲🌲🗻🏃🗻🏃🏃🏃
🌊🌲🗻🏃🏃🏃🗻🗻
🌊🌊🌊🌲🌲🌲🗻🌲
"""
  static let expectedRightDiagonals = """
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🌲🌲🏃🌲🌲
🌲🌲🌲🌲🗻🌲🏃🌲
🌲🌲🗻🗻🗻🗻🗻🏃
🌲🌲🗻🌲🏁🗻🏃🌊
🌲🌲🗻🌲🗻🏃🌲🌊
🌊🌲🗻🌲🌲🌲🗻🗻
🌊🌊🌲🌲🌲🌲🗻🌲
"""

  static let expectedDirect = """
🌊🌲🌲🌲🚩🌲🌲🌲
🌊🌲🌲🌲🏃🌲🌲🌲
🌲🌲🌲🌲🏃🌲🌲🌲
🌲🌲🗻🗻🏃🗻🗻🌲
🌲🌲🗻🌲🏁🗻🌊🌊
🌲🌲🗻🌲🗻🌲🌲🌊
🌊🌲🗻🌲🌲🌲🗻🗻
🌊🌊🌲🌲🌲🌲🗻🌲
"""

  static let dataAlt: [[Pattern]] = [
    [.🌊, .🌲, .🌲, .🌲, .🚩, .🌲, .🌲, .🌲],
    [.🌊, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🌲, .🌲, .🗻, .🌲, .🌲, .🌲],
    [.🌲, .🌲, .🗻, .🗻, .🗻, .🗻, .🗻, .🌲],
    [.🌲, .🌲, .🗻, .🌲, .🏁, .🗻, .🌊, .🌊],
    [.🌲, .🌲, .🗻, .🌲, .🗻, .🌲, .🌲, .🌊],
    [.🌊, .🌲, .🗻, .🌲, .🌲, .🌲, .🗻, .🗻],
    [.🌊, .🌊, .🌊, .🌲, .🌲, .🌲, .🗻, .🌲] // extra cost to force alt route
  ]

  func mapOracle<Cost>(
    data: [[Pattern]] = Self.data,
    useDiagonals: Bool = false,
    customDistance: ((Coord2D, Coord2D) -> Cost)? = nil,
    customCost: ((Pattern) -> Cost)? = nil,
    customVisitable: ((Pattern) -> Bool)? = nil
  ) -> MapOracle<Cost> {
    .init(
      data: data,
      useDiagonals: useDiagonals,
      customDistance: customDistance,
      customCost: customCost,
      customVisitable: customVisitable
    )
  }

  @Test
  func noDiagonals() throws {
    let oracle: MapOracle<Int> = mapOracle()
    let path = try AStar.find(
      oracle: oracle,
      start: start,
      end: end
    )

    #expect(path != nil)
    #expect(path?.count == 17)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 16)
    #expect(path?.map(\.locationCost).filter { $0 == 0 }.count == 2)
    #expect(path?.map(\.locationCost).filter { $0 == 1 }.count == 14)
    #expect(path?.map(\.locationCost).filter { $0 == 2 }.count == 1)
    #expect(path?.map(\.locationCost).filter { $0 == 99 } == [])

    let image = oracle.asString(path: path)
    #expect(image == Self.expectedLeft)
  }

  @Test
  mutating func noDiagonalsPythagoreanDistance() throws {
    let oracle: MapOracle<Float> = mapOracle(customDistance: { $0.distance(to: $1) })
    let path = try AStar.find(
      oracle: oracle,
      start: start,
      end: end
    )

    #expect(path != nil)
    #expect(path?.count == 17)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 16)
    #expect(path?.map(\.locationCost).filter { $0 == 0 }.count == 2)
    #expect(path?.map(\.locationCost).filter { $0 == 1 }.count == 14)
    #expect(path?.map(\.locationCost).filter { $0 == 2 }.count == 1)
    #expect(path?.map(\.locationCost).filter { $0 == 99 } == [])

    let image = oracle.asString(path: path)
    #expect(image == Self.expectedLeft)
  }

  @Test
  mutating func noDiagonalsAlt() throws {
    let oracle: MapOracle<Int> = mapOracle(
      data: Self.dataAlt,
      customCost: {
        switch $0 {
        case .🌲, .🌊: return 1
        case .🗻: return 99
        default: return 0
        }
      }
    )

    let path = try AStar.find(
      oracle: oracle,
      start: start,
      end: end
    )

    #expect(path != nil)
    #expect(path?.count == 17)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 15)
    #expect(path?.map(\.locationCost).filter { $0 == 0 }.count == 2)
    #expect(path?.map(\.locationCost).filter { $0 == 1 }.count == 15)
    #expect(path?.map(\.locationCost).filter { $0 == 99 } == [])

    let image = oracle.asString(path: path)
    #expect(image == Self.expectedRight)
  }

  @Test
  func noDiagonalsFloat() throws {
    let oracle: MapOracle<Float> = mapOracle()
    let path = try AStar.find(
      oracle: oracle,
      start: start,
      end: end
    )

    #expect(path != nil)
    #expect(path?.count == 17)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 16.0)
    #expect(path?.map(\.locationCost).filter { $0 == 0 }.count == 2)
    #expect(path?.map(\.locationCost).filter { $0 == 1 }.count == 14)
    #expect(path?.map(\.locationCost).filter { $0 == 2 }.count == 1)
    #expect(path?.map(\.locationCost).filter { $0 == 99 } == [])

    let image = oracle.asString(path: path)
    #expect(image == Self.expectedLeft)
  }

  @Test
  mutating func diagonals() throws {
    let oracle: MapOracle<Int> = mapOracle(useDiagonals: true)
    let path = try AStar.find(
      oracle: oracle,
      start: start,
      end: end
    )

    #expect(path != nil)
    #expect(path?.count == 7)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 6)
    #expect(path?.map(\.locationCost).filter { $0 == 0 }.count == 2)
    #expect(path?.map(\.locationCost).filter { $0 == 1 }.count == 4)
    #expect(path?.map(\.locationCost).filter { $0 == 2 }.count == 1)
    #expect(path?.map(\.locationCost).filter { $0 == 99 } == [])

    let image = oracle.asString(path: path)
    #expect(image == Self.expectedRightDiagonals)
  }

  @Test
  mutating func sameCostAllVisitable() async throws {
    let oracle: MapOracle<Float> = mapOracle(
      customDistance: { $0.distance(to: $1) },
      customCost: { _ in 1 },
      customVisitable: { _ in true }
    )

    let path = try AStar.find(
      oracle: oracle,
      start: start,
      end: end
    )

    #expect(path != nil)
    #expect(path?.count == 5)
    #expect(path?.first?.runningCost == 0)
    #expect(path?.last?.runningCost == 4)
    #expect(path?.map(\.locationCost).filter { $0 == 0 }.count == 1)
    #expect(path?.map(\.locationCost).filter { $0 == 1 }.count == 4)
    #expect(path?.map(\.locationCost).filter { $0 == 2 } == [])
    #expect(path?.map(\.locationCost).filter { $0 == 99 } == [])

    let image = oracle.asString(path: path)
    #expect(image == Self.expectedDirect)
  }

  @Test
  func noPath() throws {
    let start = Coord2D(x: 7, y: 7)
    let path = try AStar<MapOracle<Int>>.find(
      oracle: mapOracle(),
      start: start,
      end: end
    )
    #expect(path == nil)
  }

  @Test
  func invalidStart() throws {
    let start = Coord2D(x: -1, y: 0)
    #expect(throws: AStar<MapOracle<Int>>.Failure.invalidStart) {
      try AStar<MapOracle<Int>>.find(
        oracle: mapOracle(),
        start: start,
        end: end
      )
    }
  }

  @Test
  func invalidEnd() throws {
    #expect(throws: AStar<MapOracle<Int>>.Failure.invalidEnd) {
      try AStar<MapOracle<Int>>.find(
        oracle: mapOracle(),
        start: start,
        end: Coord2D(x: 4, y: 1000)
      )
    }
  }

  @Test
  func sameStartEnd() throws {
    #expect(throws: AStar<MapOracle<Int>>.Failure.sameStartEnd) {
      try AStar<MapOracle<Int>>.find(
        oracle: mapOracle(),
        start: start,
        end: start
      )
    }
  }
}

private enum Pattern {
  // swiftlint:disable:next identifier_name
  case 🚩, 🌊, 🗻, 🌲, 🏁
}

private struct MapOracle<Cost: NumericCost>: GraphOracle {

  typealias Location = Coord2D

  private let map: [[Pattern]]
  private let bounds: (x: Range<Int>, y: Range<Int>)

  var customDistance: ((Coord2D, Coord2D) -> Cost)
  var customCost: (Pattern) -> Cost
  var customVisitable: (Pattern) -> Bool
  var useDiagonals: Bool = false

  init(
    data: [[Pattern]],
    useDiagonals: Bool = false,
    customDistance: ((Coord2D, Coord2D) -> Cost)? = nil,
    customCost: ((Pattern) -> Cost)? = nil,
    customVisitable: ((Pattern) -> Bool)? = nil
  ) {
    self.map = data
    self.useDiagonals = useDiagonals
    self.bounds = (
      x: 0..<(data.map(\.count).max() ?? 1),
      y: 0..<data.count
    )
    self.customDistance = customDistance ?? { Cost.distance(from: $0, to: $1) }
    self.customCost = customCost ?? {
      switch $0 {
      case .🌲: return 1
      case .🌊: return 2
      default: return 0
      }
    }
    self.customVisitable = customVisitable ?? {
      switch $0 {
      case .🗻: return false
      default: return true
      }
    }
  }

  func asString(path: [Position<Location, Cost>]?) -> String {
    guard let path else { return "" }
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

extension MapOracle {

  @inlinable
  func inBounds(position: Location) -> Bool {
    bounds.x.contains(position.x) && bounds.y.contains(position.y)
  }

  @inlinable
  func canVisit(location: Location) -> Bool {
    inBounds(position: location) && customVisitable(self[location])
  }

  @inlinable
  func cost(entering location: Location) -> Cost {
    customCost(self[location])
  }

  @inlinable
  func distance(from: Location, to: Location) -> Cost {
    customDistance(from, to)
  }

  func adjacentLocations(to location: Coord2D) -> [Coord2D] {
    let offsets: [Offset2D] = (
      [.init(dx: -1, dy: 0), .init(dx: 0, dy: -1), .init(dx: 0, dy: 1), .init(dx: 1, dy: 0)] +
      (useDiagonals ? [.init(dx: -1, dy: -1), .init(dx: -1, dy: 1), .init(dx: 1, dy: -1), .init(dx: 1, dy: 1)] : [])
    )
    return offsets.map { location + $0 }.filter { canVisit(location: $0) }
  }
}
