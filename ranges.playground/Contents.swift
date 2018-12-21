import Foundation

// Half range range
let singleDigitNumbers = 0..<10
let lowercaseAlphabets = Character("a")..<Character("z")
print(Array(singleDigitNumbers))

singleDigitNumbers.contains(9) // true
lowercaseAlphabets.overlaps("c"..<"f") // true
