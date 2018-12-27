import Foundation

struct Credentials {
    let username: String
    let password: String
}

func signUpIfPossible(with credentials: Credentials) {

    guard credentials.username.count >= 3 else {
        print("Username must contain min 3 characters")
        return
    }
    
    guard credentials.password.count >= 7 else {
        print("Password must contain min 7 characters")
        return
    }
    // Additional validation
    print("Success")
}
let credentials = Credentials(username: "vino1234", password: "12345")
//signUpIfPossible(with: credentials)


struct Validator<Value> {
    let closure: (Value) throws -> Void
}

/*:
 Using the above, we'll be able to construct validators that throw an error whenever a value didn't pass validation. However, having to always define a new Error type for each validation process might again generate unnecessary boilerplate (especially if all we want to do with an error is to display it to the user) - so let's also introduce a function that lets us write validation logic by simply passing a Bool condition and a message to display to the user in case of a failure:
 */

struct ValidationError: LocalizedError {
    let message: String
    var errorDescription: String? { return message }
}

func validate(
    _ condition: @autoclosure () -> Bool,
    errorMessage messageExpression: @autoclosure () -> String
    ) throws {
    guard condition() else {
        let message = messageExpression()
        throw ValidationError(message: message)
    }
}
/*
func passwordValidator() -> Validator<String> {
    return Validator { string in
        try validate(
            string.count >= 7,
            errorMessage: "Password must contain min 7 characters"
        )
    }
}
 */
extension Validator where Value == String {
    static var password: Validator {
        return Validator { string in
            try validate(
                string.count >= 7,
                errorMessage: "Password must contain min 7 characters"
            )
            
            try validate(
                string.lowercased() != string,
                errorMessage: "Password must contain an uppercased character"
            )
            
            try validate(
                string.uppercased() != string,
                errorMessage: "Password must contain a lowercased character"
            )
        }
    }
    
    static var username: Validator {
        return Validator { string in
            try validate(
                string.count >= 7,
                errorMessage: "Username must contain min 7 characters"
            )
        }
    }
}


func validate<T>(_ value: T,
                 using validator: Validator<T>) throws {
    try validator.closure(value)
}

func signUpIfPossibleExt(with credentials: Credentials) throws {
    try validate(credentials.username, using: .username)
    try validate(credentials.password, using: .password)
    print("Success")
}

do {
    try signUpIfPossibleExt(with: credentials)
} catch {
    print(error)
}
