import Testing

@testable import AStar

@Suite
struct AStarTests {

  let end = Coord2D(x: 4, y: 4)

  func calcHeuristicCostInt(position: Coord2D) -> Int { abs(position.x - end.x) + abs(position.y - end.y) }

  let mapDataIntCost = MapData<Int>(data: [
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

  @Test
  func noDiagonals() throws {
    let start = Coord2D(x: 4, y: 0)
    let path = try AStar<MapData<Int>>.find(
      mapOracle: mapDataIntCost,
      considerDiagonalPaths: false,
      heuristicCostCalulator: calcHeuristicCostInt,
      start: start,
      end: end
    )
    #expect(path != nil)

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
  func noDiagonalsFloat() throws {
    let start = Coord2D(x: 4, y: 0)
    let path = try AStar<MapData<Float>>.find(
      mapOracle: mapDataFloatCost,
      considerDiagonalPaths: false,
      heuristicCostCalulator: calcHeuristicCostFloat,
      start: start,
      end: end
    )
    #expect(path != nil)

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
  func diagonals() throws {
    let start = Coord2D(x: 4, y: 0)
    let path = try AStar.find(
      mapOracle: mapDataIntCost,
      considerDiagonalPaths: true,
      heuristicCostCalulator: calcHeuristicCostInt,
      start: start,
      end: end
    )
    #expect(path != nil)

    let image = mapDataIntCost.asString(path: path!)
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
    #expect(image == expected)
  }

  @Test
  func noPath() throws {
    let start = Coord2D(x: 7, y: 7)
    let path = try AStar.find(
      mapOracle: mapDataIntCost,
      considerDiagonalPaths: true,
      heuristicCostCalulator: calcHeuristicCostInt,
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
        heuristicCostCalulator: calcHeuristicCostInt,
        start: start,
        end: end
      )
    }
  }

  @Test
  func invalidEnd() throws {
    let start = Coord2D(x: 4, y: 0)
    #expect(throws: AStarError.invalidEnd) {
      try AStar.find(
        mapOracle: mapDataIntCost,
        considerDiagonalPaths: true,
        heuristicCostCalulator: calcHeuristicCostInt,
        start: start,
        end: Coord2D(x: 4, y: 1000)
      )
    }
  }

  @Test
  func sameStartEnd() throws {
    let start = Coord2D(x: 4, y: 0)
    #expect(throws: AStarError.sameStartEnd) {
      try AStar.find(
        mapOracle: mapDataIntCost,
        considerDiagonalPaths: true,
        heuristicCostCalulator: calcHeuristicCostInt,
        start: start,
        end: start
      )
    }
  }
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
      case .🗻: return 99
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

  func cost(position: Coord2D) -> CostType { self[position].cost }
}
