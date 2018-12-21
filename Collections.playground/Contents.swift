/*:
 
 **Collections**

A collection builds on top of a sequence and adds repeatable iteration and access to the elements via an index.
 
 */

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

//: **Collection Protocol**
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

/*:
 
 # Conforming to ArrayLiteralConvertible

 When implementing a collection like this, it’s nice to implement ArrayLiteralConvertible too.
 This will allow users to create a queue using the familiar [value1, value2, etc] syntax. This can be done easily, like so:
 */

extension Queue: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = Element
    
    init(arrayLiteral elements: ArrayLiteralElement...) {
        self.left = elements.reversed()
        self.right = []
    }
}
var qu: Queue = [1, 2, 3]
print(qu)

/*:
 
 # Conforming to RangeReplaceableCollectionType
 
 The next logical protocol for queues to adhere to is RangeReplaceableCollectionType. This protocol requires three things:
 
 **A reserveCapacity method** — we used this when implementing map. Since the number of final elements is known up front, it can avoid unnecessary element copies when the array reallocates its storage. The collection is not required to actually do anything when asked to reserve capacity; it can just ignore it.
 
 **An empty initializer** — this is useful in generic functions, as it allows a function to create new empty collections of the same type.
 
 **A replaceRange function** — this takes a range to replace and a collection to replace it with.
 
 **RangeReplaceableCollectionType** is a great example of the power of protocol extensions. You implement one uber flexible method, replaceRange, and from that comes a whole bunch of derived methods for free:
 
 **append and appendContentsOf** — replace endIndex..<endIndex (i.e. replace the empty range at the end) with the new element/elements
 
 **removeAtIndex and removeRange** — replace i...i or subRange with an empty collection
 
 **splice and insertAtIndex** — replace atIndex..<atIndex (i.e. replace the empty range at that point in the array) with a new element/elements
 
 **removeAll** — replace startIndex..<endIndex with an empty collection
 
 */

extension Queue: RangeReplaceableCollection {
    mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, Element == C.Element, Int == R.Bound {
        self.right = self.left.reversed() + self.right
        self.left = []
        self.right.replaceSubrange(subrange, with: newElements)
    }
}

qu.append(4)
print(qu)
qu.append(contentsOf: [5, 6, 7])
print(qu)

qu.remove(at: 4)
print(qu)

qu.insert(5, at: 4)
print(qu)
print(qu.removeAll())
