// Copyright © 2020 Brad Howes. All rights reserved.

/**
 Interface for a type that will hold the cost of an AStar node. Since nodes will be ordered by their cost, we need to
 have `<` operator.
 */
public protocol CostNumeric: SignedNumeric {
    static func < (lhs: Self, rhs: Self) -> Bool
}

extension Int: CostNumeric {}
extension Float: CostNumeric {}
extension Double: CostNumeric {}
