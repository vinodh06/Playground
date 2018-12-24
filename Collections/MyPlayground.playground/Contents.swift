import Foundation

extension Array {
    func custommap<U>(transform: (Element)->U) -> [U] {
        var result: [U] = []
        result.reserveCapacity(self.count)
        for x in self {
            result.append(transform(x))
        }
        return result
    }
    
    func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result {
        var result = initialResult
        for x in self {
            result = try nextPartialResult(result, x)
        }
        return result
    }
    
    func customFlatMap<U>(transform: (Element) -> [U]) -> [U] {
        var values: [U] = []
        for x in self {
            values.append(contentsOf: transform(x))
        }
        return values
    }
    
}


let suits = ["♠︎", "♥︎", "♣︎", "♦︎"]
let ranks = ["J","Q","K","A"]
let allCombinations = suits.customFlatMap { suit in
    ranks.map { rank in
    (suit, rank)
    }
}
//print(allCombinations)


extension Array where Element: Equatable {
    func indexOf(element: Element) -> Int? {
        for idx in self.indices where self[idx] == element {
            return idx
        }
        return nil
    }
}

[1,2,3,1].indexOf(element: 1)


