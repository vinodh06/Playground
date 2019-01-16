import Foundation
//import Unbox

/*:
 
 Future:
 Future provides a way to access the result of asynchronous operations. You can imagine we use this to avoid the tedious part of getting the results from the threads.
 
 Promise:
 Promise is where a task can deposit its result to be retrieved through a future. In other words, promise is a way to have a single point of synchronization between two threads without being the end of one of them.
 
 Future and Promise are the two separate sides of an asynchronous operation.
 
 promise is used by the "producer/writer" of the asynchronous operation.
 
 future is used by the "consumer/reader" of the asynchronous operation.
 
 The reason it is separated into these two separate "interfaces" is to hide the "write/set" functionality from the "consumer/reader".
 */



enum Result<Value> {
    case value(Value)
    case error(Error)
}

class Future<Value> {
    
    fileprivate var result: Result<Value>? {
        // Observe whenever a result is assigned, and report it
        didSet { result.map(report) }
    }
    private lazy var callbacks = [(Result<Value>) -> Void]()
    
    func observe(with callback: @escaping (Result<Value>) -> Void) {
        callbacks.append(callback)
        
        // If a result has already been set, call the callback directly
        result.map(callback)
    }
    
    private func report(result: Result<Value>) {
        for callback in callbacks {
            callback(result)
        }
    }
}

class Promise<Value>: Future<Value> {
    init(value: Value? = nil) {
        super.init()
        
        // If the value was already known at the time the promise
        // was constructed, we can report the value directly
        result = value.map(Result.value)
    }
    
    func resolve(with value: Value) {
        result = .value(value)
    }
    
    func reject(with error: Error) {
        result = .error(error)
    }
}

extension String: Error {}

extension URLSession {
    
    func request(url: URL) -> Future<Data> {
        // Start by constructing a Promise, that will later be
        // returned as a Future
        let promise = Promise<Data>()
        
        // Perform a data task, just like normal
        let task = dataTask(with: url) { data, urlResponse, error in
            // Reject or resolve the promise, depending on the result
            if let error = error {
                promise.reject(with: error)
            }
            
            if let response = urlResponse as? HTTPURLResponse, response.statusCode != 200 {
                let message: String = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                promise.reject(with: message)
            } else {
                promise.resolve(with: data ?? Data())
            }
            
        }
        
        task.resume()
        
        return promise
    }
    
}


if let apple_stock_url = URL(string: "https://api.iextrading.com/1.0/stock/googl/price") {
    let requestFuture = URLSession.shared.request(url: apple_stock_url)
    requestFuture.observe { result in
        switch result {
        case .value(let value):
            if let stock_price = String(data: value, encoding: String.Encoding.utf8) {
                print(stock_price)
            }
        case .error(let error):
            print(error)
        }
    }
    print("Finished")
}



/*
class StockLoader {
    
    typealias Handler = (Result<String>) -> Void
    
    func loadStockPrice(completionHandler: @escaping Handler) {
        if let apple_stock_url = URL(string: "https://api.iextrading.com/1.0/stock/googl/price") {
            let task = URLSession.shared.dataTask(with: apple_stock_url)
            {  data, _, error in
                
                if let error = error {
                    completionHandler(.error(error))
                } else {
                        let stock_price = String(data: data!, encoding: String.Encoding.utf8)!
                        completionHandler(.value(stock_price))
                }
            }
            task.resume()
        }
    }
}

let stockLoader = StockLoader()
stockLoader.loadStockPrice(completionHandler: {
    result in
    print(result)
})
*/


/*
 let promise = Promise<Int>(value: 5)
 promise.observe{ result in
 switch result {
 case .value(let value):
 print(value)
 default:
 print("error")
 }
 }
 promise.resolve(with: 10)
 sleep(5)
 promise.resolve(with: 15)
 */

/*
 func accumUpto(x: Int, sleeptime: UInt32) -> Future<Int> {
 print("started")
 var accum = 0
 
 let promise = Promise<Int>(value: 5)
 
 for i in 1...x {
 
 accum += i
 }
 sleep(sleeptime)
 //    sleep(60)
 promise.resolve(with: accum)
 return promise
 }
 
 var future = accumUpto(x: 20, sleeptime: 15)
 future.observe{ result in
 switch result {
 case .value(let value):
 print(value)
 default:
 print("error")
 }
 }
 */
