//: Playground - noun: a place where people can play

import Foundation
/*:
Value types are very common in Swift. Most of the types in the standard library are either structs or enums, and memory management for them is very easy. Because they have a single owner, the memory needed for them is created and freed automatically. When using value types, you can’t create cyclic references. For example, consider the following snippet:
*/
struct Person {
    let name: String
    var parents: [Person]
}
var john = Person(name: "John", parents: [])
john.parents = [john]
print(john)

/*:
 Swift structs are commonly stored on the stack rather than on the heap. However, there are exceptions. If a struct has a dynamic size, or if a struct is too large, it will be stored on the heap. Also, if a struct value is closed over by a function (like in the examples using closures), the value is stored on the heap so that it persists, even when the scope it’s defined in will exit.
 */
/*:
 
 # Weak, Unowned
 http://www.thomashanning.com/swift-weak-and-unowned/
 */


