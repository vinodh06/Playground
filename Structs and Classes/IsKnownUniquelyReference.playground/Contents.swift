
/*:
 # How to safely use reference types inside value types with isKnownUniquelyReferenced()
 */
import Foundation

/*:
Working with value types like structs and enums makes your code easier to write, easier to test, and easier to reason about. However, they aren’t always possible: classes and closures are both reference types, and are used extensively in Swift for the handful of times when sharing data is important, or perhaps because you’re using them through someone else’s Swift code.

This can cause a variety of side effects with your code: if you use reference types inside value types, they still behave like reference types. The solution to this is to wrap those reference types in value semantics, meaning that they behave more like value types.

To demonstrate the problem, consider this ChatHistory class:
 */

class ChatHistory: NSCopying {
    var messages: String = "Anonymous"
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ChatHistory()
        copy.messages = messages
        return copy
    }
}

struct User {
    var chats = ChatHistory()
}

let twostraws = User()
twostraws.chats.messages = "Hello!"
/*:
Although that’s a value type – meaning that it may have only one owner at a time – it doesn’t really behave like one. You can see we’re modifying the struct directly, even though it’s marked as a constant. We could also create a different struct and make it re-use the same chats property:
*/

var taylor = User()
taylor.chats = twostraws.chats
/*
Because we made taylor.chats point to the same object as twostraws.chats – a reference type – then changing one will also change the other. So, this will print “Goodbye!” twice:
*/
twostraws.chats.messages = "Goodbye!"
print(twostraws.chats.messages)
print(taylor.chats.messages)

/*:
 To fix this we’re going to change the implementation of User so that messages becomes a private property called _messages, and expose a custom getter/setter called messages that will act in its place. The setter part will just change _messages directly, but the getter will take a copy of _messages before returning it so that our properties are always unique.
 
 To do this we’re going to use Swift’s mutating getters, which are enabled using the mutating get keyword. This allows us to change the struct inside the getter, and Swift will back this up by refusing to allow it when used with constants.
 */


struct User2 {
    var _chats = ChatHistory()
    
    var chats: ChatHistory {
        mutating get {
            _chats = _chats.copy() as! ChatHistory
            print("count")
            return _chats
        }
        
        set {
            _chats = newValue
        }
    }
}

var twostraws2 = User2()
twostraws2.chats.messages = "HEllO"

var taylor2 = User2()
taylor2.chats = twostraws2.chats

//taylor2.chats.messages = "HAI"
print(twostraws2.chats.messages)
print(taylor2.chats.messages)


/*:
 This makes sense, because we are changing it. However, it introduces a new problem: all that copying is quite wasteful if you do repeated work when the messages object was unique all along.
 
 To fix this new problem you need the isKnownUniquelyReferenced() function, which returns true when called on an instance of a Swift class that has only one owner.isKnownUniquelyReferenced(). This means we can return _chats if it is uniquely referenced (no one else has a reference to it), otherwise we’ll take a copy. This reduces copying down to the bare minimum, which is much more efficient.
 */

struct User3 {
    private var _chats = ChatHistory()
    
    var chats: ChatHistory {
        mutating get {
            if !isKnownUniquelyReferenced(&_chats) {
                print("count2")
                _chats = _chats.copy() as! ChatHistory
            }
            
            return _chats
        }
        
        set {
            _chats = newValue
        }
    }
}

var twostraws3 = User3()
twostraws3.chats.messages = "HEllO"

var taylor3 = User3()
taylor3.chats = twostraws3.chats

//taylor3.chats.messages = "HAI"
print(twostraws3.chats.messages)
print(taylor3.chats.messages)
