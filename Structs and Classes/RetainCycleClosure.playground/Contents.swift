import Foundation

/*:
 # Common scenarios for retain cycles: closures
*/

class TestClass {
    
    var aBlock: (() -> ())? = nil
    
    let aConstant = 5
    
    
    init() {
        print("init")
        aBlock = {
            print(self.aConstant)
        }
    }
    
    deinit {
        print("deinit")
    }
    
    
}

var testClass: TestClass? = TestClass()
testClass = nil
/*:
 We can see in the logs that the instance of TestClass will not be deallocated. The problem is, that TestClass has a strong reference to the closure and the closure has a strong reference to TestClass
 
 You can solve this by capturing the  self reference as weak:
 
*/

class TestClass2 {
    
    var aBlock: (() -> ())? = nil
    
    let aConstant = 5
    
    
    init() {
        print("init")
        
        // weak reference
        aBlock = { [weak self] in    //self is captured as weak!
            print(self?.aConstant ?? "0")
        }
        
        // unowned reference
        aBlock = { [unowned self] in    //self is captured as weak!
            print(self.aConstant)
        }
        
    }
    
    deinit {
        print("deinit")
    }
    
    
}

var testClass2: TestClass2? = TestClass2()
testClass2?.aBlock?()
testClass2 = nil

/*:
    Please refer this link to find the retain cycle by instruments
    http://www.thomashanning.com/retain-cycles-weak-unowned-swift/
 */

