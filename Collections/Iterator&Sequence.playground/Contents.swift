//: Playground - noun: a place where people can play

import Foundation


// Swift 3.0 - Generator
// Swift 4.0 - IteratorProtocol
/*
class ConstantGenerator: IteratorProtocol{
    var state = (0,1)

    func next() -> Int? {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}

var generator = ConstantGenerator()
var i = 0
while i < 5 {
    print(generator.next()!)
    i = i + 1
}

class PrefixGenerator: IteratorProtocol {
    let string: String
    var offset: String.Index
    typealias Element = String
    init(string: String){
        self.string = string
        offset = string.startIndex
    }
    
    func next() -> PrefixGenerator.Element? {
        guard offset < string.endIndex else { return nil }
        offset = string.index(after: offset)
        return String(self.string[self.string.startIndex..<offset])
    }
    
}

var prefixgen = PrefixGenerator(string: "String")

while true {
    if let x = prefixgen.next() {
        print(x)
    } else {
        break
    }
}

class PrefixSequence: Sequence {
    let string: String
    
    init(string: String) {
        self.string = string
    }
    
    func makeIterator() -> PrefixGenerator {
        return PrefixGenerator(string: string)
    }
}

for prefix in PrefixSequence(string: "Hello") {
    print(prefix)
}


let a = [1,2,3]

var iterat = a.makeIterator()
while let i = iterat.next() {
    print(i)
}


//Function-Based Generators and Sequences

func fibIterator() -> AnyIterator<Int> {
    var state = (0, 1)
    return AnyIterator {
        let result =  state.0
        state = (state.1, state.0 + state.1)
        return result
    }
}

var fibSequence = AnySequence(fibIterator())
for i in fibSequence where i < 10 {
    print(i)
}
*/

