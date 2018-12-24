//: Playground - noun: a place where people can play

import Foundation

//Merge two dict
var dict1 = ["a":1, "b":2]
dict1["e"] = 3
var dict2 = ["e":1, "a":2]
print(dict2)
print(dict1)
dict1.merge(dict2) { (_, new) in new }
print(dict1)


//map values in dictionary
let newDict = Dictionary(uniqueKeysWithValues:
    dict1.map { key, value in (key.uppercased(), "\(value)") })
print(newDict)


enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

let defaultSettings: [String:Setting] = [
    "Airplane Mode": .bool(false),
    "Name": .text("My iPhone"),
]

defaultSettings["Name"]

var settings = defaultSettings
let overriddenSettings: [String:Setting] = ["Name": .text("Jane's iPhone")]
settings.merge(overriddenSettings){ $1 }
settings


extension Sequence where Element: Hashable {
    var frequencies: [Element:Int] {
        let frequencyPairs = self.map { ($0, 1) }
        return Dictionary(frequencyPairs, uniquingKeysWith: +)
    }
}
let frequencies = "hello".frequencies // ["e": 1, "o": 1, "l": 2, "h": 1]
print(frequencies.filter { $0.value > 1 }) // ["l": 2]


let settingsAsStrings = settings.mapValues { setting -> String in
    switch setting {
    case .text(let text): return text
    case .int(let number): return String(number)
    case .bool(let value): return String(value)
    }
}
settingsAsStrings // ["Name": "Jane\'s iPhone", "Airplane Mode": "false"]
