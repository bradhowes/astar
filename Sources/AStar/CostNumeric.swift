// Copyright © 2020 Brad Howes. All rights reserved.

/**
 Interface for a type that will hold the cost of an AStar node. We need to be able to compare them and
 to represent a zero cost.
 */

public protocol CostNumeric: SignedNumeric, Comparable {}

extension Int: CostNumeric {}
extension Float: CostNumeric {}
extension Double: CostNumeric {}
