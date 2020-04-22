// Copyright © 2020 Brad Howes. All rights reserved.
//

import Foundation

/**
 Generic container that maintains a heap: all parent nodes but the last contain 2 children (last parent can contain 1 child). Each parent appears in the container before
 its children, ordered by a provided function.
 */
public struct PriorityQueue<T> {
    public typealias ElementType = T

    /// Defines a function type that returns true if the two areguments are considered in order.
    public typealias IsOrderedOp = (ElementType, ElementType) -> Bool
    /// Obtain the number of items currently in the queue
    public var count: Int { heap.count }
    /// Determine if the container is empty
    public var isEmpty: Bool { heap.isEmpty }
    /// Return the first item in the queue if there is one. Does not remove it from the queue.
    public var first: ElementType? { heap.first }

    private let isOrdered: IsOrderedOp
    private var heap: [ElementType] = []

    /**
     Intialize new instance. Populates queue with any given items (optional)
     - parameter args: zero or more items to add to queue
     - parameter compare: function that determines ordering of items in the queue
     elements in ascending order
     */
    public init(_ args: ElementType..., compare: @escaping IsOrderedOp) {
        self.isOrdered = compare
        args.forEach { push($0) }
    }
    /**
     Intialize new instance.

     - parameter compare: function that determines the ordering of itesm int the queue
     - parameter values: collection of items to add
     */
    public init(_ compare: @escaping IsOrderedOp, values: [ElementType]) {
        self.isOrdered = compare
        values.forEach { push($0) }
    }

    /**
     Add a new item to the queue while maintaining heap property.
     - parameter item: the new item to add
     */
    public mutating func push(_ item: ElementType) {
        heap.append(item)
        _ = siftUp(index: heap.endIndex - 1)
    }

    /**
     Remove the first item from the queue and return it
     - returns: first item or nil if queue is empty
     */
    public mutating func pop() -> ElementType? {
        switch count {
        case 0: return nil
        case 1: return heap.removeLast()
        default:
            defer { _ = siftDown(index: 0) }
            heap.swapAt(0, heap.endIndex - 1)
            return heap.removeLast()
        }
    }

    /// Remove all entries from the queue
    public mutating func removeAll() { heap.removeAll() }
}

extension PriorityQueue {

    public typealias ForEachBlockType = (ElementType)->()

    /**
     Allow destructive iteration over the queue, handing the next ordered element the queue to the given closure.
     - parameter block: the closure to call to process the element
     */
    public mutating func forEach(block: ForEachBlockType) {
        while let element = pop() {
            block(element)
        }
    }
}

extension PriorityQueue {

    private func isOrdered(_ left: Int, _ right: Int) -> Bool { isOrdered(heap[left], heap[right]) }

    private mutating func siftDown(index: Int, swapped: Bool = false) -> Bool {
        var best = index
        let left = index * 2 + 1
        if left < heap.count && isOrdered(left, best) {
            best = left
        }

        let right = index * 2 + 2
        if right < heap.count && isOrdered(right, best) {
            best = right
        }

        if best == index { return swapped }

        heap.swapAt(index, best)
        return siftDown(index: best, swapped: true)
    }

    private mutating func siftUp(index: Int, swapped: Bool = false) -> Bool {
        guard index > 0 else { return swapped }
        let parent = (index - 1) >> 1
        if isOrdered(parent, index) { return swapped }
        heap.swapAt(index, parent)
        return siftUp(index: parent, swapped: true)
    }
}

extension PriorityQueue where ElementType: Equatable {

    /**
     Determine if container holds the given value.

     - parameter value: the value to look for
     - returns: true if found
     */
    public func contains(_ value: ElementType) -> Bool { heap.contains(value) }

    /**
     Update an entry in the queue, possibly reording its position.
     - parameter element: the item to update
     - returns: the item if it was moved or nil if item was not found or its position did not change
     */
    public mutating func update(element: ElementType) -> ElementType? {
        for (index, item) in heap.enumerated() {
            if item == element {
                heap[index] = element

                // Assume that the new entry is different than the old one. Try to rebalance upward first. If that did
                // not induce a swap, then try and rebalance downward.
                //
                if !siftDown(index: index) { _ = siftUp(index: index) }
                return item
            }
        }
        return nil
    }

    /**
     Remove an entry from the priority queue.
     - parameter element: the entry to remove
     - returns: the element that was removed or nil if not found
     */
    public mutating func remove(element: ElementType) -> ElementType? {
        for (index, item) in heap.enumerated() {
            if item == element {
                heap.swapAt(index, heap.endIndex - 1)
                heap.removeLast()
                _ = siftDown(index: index)
                return item
            }
        }
        return nil
    }
}

extension PriorityQueue where ElementType: Comparable {

    /**
     Generic comparison function for Comparable types that provides for max value ordering

     - parameter lhs: first value to compare
     - parameter rhs: second value to compare
     - returns: true if first value >= second value
     */
    public static func MaxComp(_ lhs: ElementType, _ rhs: ElementType) -> Bool { lhs >= rhs }

    /**
     Generic comparison function for Comparable types that provides for min value ordering

     - parameter lhs: first value to compare
     - parameter rhs: second value to compare
     - returns: true if first value <= second value
     */
    public static func MinComp(_ lhs: ElementType, _ rhs: ElementType) -> Bool { lhs <= rhs }

    /**
     Factory method for creating a PriorityQueue with max-value ordering

     - parameter args: values to add to the queue
     - returns: the new PriorityQueue instance
     */
    static public func MaxOrdering(_ args: ElementType...) -> PriorityQueue { PriorityQueue(MaxComp, values: args) }

    /**
     Factory method for creating a PriorityQueue with min-value ordering

     - parameter args: values to add to the queue
     - returns: the new PriorityQueue instance
     */
    static public func MinOrdering(_ args: ElementType...) -> PriorityQueue { PriorityQueue(MinComp, values: args) }

    /**
     Convenience constructor for a PriorityQueue with min-value ordering.

     - parameter args: initial values to add to the queue
     */
    public init(_ args: ElementType...) {
        isOrdered = Self.MinComp
        args.forEach { push($0) }
    }
}
