//: Playground - noun: a place where people can play

import Foundation

protocol queueType {
    associatedtype Element

    mutating func enqueue(newElement: Element)
    
    mutating func dequeue() -> Element?
}

struct Queue<Element>: queueType {
    
    private var left:[Element]
    private var right:[Element]
    
    
    init() {
        left = []
        right = []
    }
    mutating func enqueue(newElement: Element) {
        self.right.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        guard !(left.isEmpty && right.isEmpty) else { return nil }
        if left.isEmpty {
            left = right.reversed()
            right.removeAll(keepingCapacity: true)
        }
        return left.removeLast()
    }
}

extension Queue: Collection {
    var startIndex: Int { return 0 }
    
    var endIndex: Int { return left.count + right.count }
    
    subscript(idx: Int) -> Element {
        precondition((0..<endIndex).contains(idx), "Index out of bounds")
        if idx < left.endIndex {
            return left[left.count - self.index(after: idx)]
        } else {
            return right[idx - left.count]
        }
    }
    
    func index(after i: Int) -> Int {
        return i + 1
    }
}

var q = Queue<String>()
for x in ["1", "2", "foo", "3"] {
    q.enqueue(newElement: x)
}

print(q.compactMap { Int($0) })
print(q.filter{$0.count > 1})
