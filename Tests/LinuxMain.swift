import XCTest

import AStarTests

var tests = [XCTestCaseEntry]()
tests += AStarTests.allTests()
tests += Coord2DTests.allTests()
XCTMain(tests)
