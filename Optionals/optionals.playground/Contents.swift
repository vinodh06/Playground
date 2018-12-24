
import Foundation

/*:
 # Optionals
 
 Swift takes enumerations further with the concept of “associated values.” These are enumeration values that can also have another value associated with them:
 
 enum Optional<T> {
 case None
 case Some(T)
 }
 In some languages, these are called “tagged unions” (or “discriminated unions”) — a union being multiple different possible types all held in the same space in memory, with a tag to tell which type is actually held. In Swift enums, this tag is the enum case.
 
 The only way to retrieve an associated value is via a switch or an if case let. Unlike with a sentinel value, you can’t accidentally use the value embedded in an Optional without explicitly checking and unpacking it.
 */

//: # Doubly Nested Optionals

let stringNumbers = ["1", "2", "temp", "3", "foo"]
let maybeInts = stringNumbers.map { Int($0) }

//for maybeInt in maybeInts {
//    print(maybeInt)
//}

for case let i? in maybeInts {
    // i will be an Int, not an Int?
    // 1, 2, and 3
    print(i)
}
/*:
 This uses a “pattern” of x?, which only matches non-nil values. This is shorthand for .Some(x), so the loop could be written like this:
 
 for case let .Some(i) in maybeInts {
 }
 */
// or only the nil values:
for case nil in maybeInts {
    // will run once for each nil
    print("Nil")
}
/*:
 # nil-Coalescing Operator

Often you want to unwrap an optional, replacing nil with some default value. This is a job for the nil-coalescing operator:
*/
let stringteger = "1"
let itemp = Int(stringteger) ?? 0
/*:
 Coalescing can also be chained — so if you have multiple possible optionals, and you want to choose the first non-optional one
 */

let i: Int? = nil
let j: Int? = nil
let k: Int? = 42
let n = i ?? j ?? k ?? 0

/*:
    You can still use ?? for this, but if the final value is also optional, the full result will be optional
 */

let m = i ?? j ?? k // m will be of type Int?


/*:
 This is often useful in conjunction with if let. You can think of this like an “or” equivalent of if let
 

if let n = i ?? j { }
// similar to if i != nil || j != nil

If you think of the ?? operator as similar to an “or” statement, you can think of an if let with multiple clauses as an “and” statement:

if let n = i, let m = j { }
// similar to if i != nil && j != nil
*/


/*
 # Optional map
*/

func doStuffWithFileExtension(fileName: String) {
    let fileExtension: String?
    if let idx = fileName.index(of: ".") {
        let extensionRange = fileName.index(after: idx)..<fileName.endIndex
        fileExtension = String(fileName[extensionRange])
    } else {
        fileExtension = nil
    }
    print(fileExtension ?? "No extension")
}

//Here’s the above function, rewritten using map:

func doStuffWithFileExtensionWithMap(fileName: String) {
    let fileExtension: String? = fileName.index(of: ".").map { idx in
        let extensionRange = fileName.index(after: idx)..<fileName.endIndex
        return String(fileName[extensionRange])
    }
    print(fileExtension ?? "No extension")
}

/*:
 # Optional Flat map
 */

let str = ["1","2","3"]
let a = str.first.map {Int($0)}
print(a! ?? 0)

let b = str.first.flatMap {Int($0)}
print(b ?? 0)


let numbers = ["boo", "1", "2", "3", "foo"]

print(numbers.map { Int($0) }.reduce(0) {    $0 + ($1 ?? 0) })

/*:
# Improving Force-Unwrap Error Messages
 */

infix operator !!

func !! <T>(wrapped: T?,  failureText: @autoclosure ()->String) -> T {
    if let x = wrapped { return x }
    fatalError(failureText())
}

let s = "foo"
//let iq = Int(s) !! "Expecting integer, got \"\(s)\""
//print(iq)

infix operator !?
func !?<T: IntegerLiteralConvertible>
    (wrapped: T?,  failureText: @autoclosure ()->String) -> T
{
    assert(wrapped != nil, failureText())
    return wrapped ?? 0
}

//let iq = Int(s) !? "Expecting integer, got \"\(s)\""
//print(iq)
