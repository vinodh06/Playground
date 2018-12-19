import Foundation

extension Array {
    func accumulate<U>(initial: U, combine: (U, Element) -> U) -> [U] {
        var running = initial
        
        return self.map{ next in
            running = combine(running, next)
            return running
        }
    }
}

[1.0,2.0,3.0,4.2].accumulate(initial: 0, combine: +)

