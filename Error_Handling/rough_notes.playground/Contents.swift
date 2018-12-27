import Foundation

var str = "Hello, playground"

struct Validator<Value> {
    let closure: (Value) throws ->  ()
}

struct ValidationError: LocalizedError {
    let message: String
    var errorDescription: String? { return message }
}

func validate(_ condition: @autoclosure () -> Bool, errorMessage messageExpression: @autoclosure () -> String) throws {
    guard condition() else {
        let message = messageExpression()
        throw ValidationError(message: message)
    }
}

extension Validator where Value == String {
    static var password: Validator {
        return Validator{
            string in
            try validate(string.count >= 6, errorMessage: "password should be more than 6 characters")
        }
    }
}


func validate<T>(_ value: T, validator: Validator<T>) throws {
    try validator.closure(value)
}

do {
    try validate("qwer", validator: .password)
} catch {
    print(error.localizedDescription)
}
