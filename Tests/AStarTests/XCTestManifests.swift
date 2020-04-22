import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AStarTests.allTests),
        testCase(Coord2DTests.allTests),
        testCase(PriorityQueueTests.allTests),
    ]
}
#endif
