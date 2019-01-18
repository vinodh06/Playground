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

/*
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
*/


if let apple_stock_url = URL(string: "https://api.iextrading.com/1.0/stock/aapl/book") {
    let requestFuture = URLSession.shared.request(url: apple_stock_url)
    requestFuture.observe { result in
        switch result {
        case .value(let value):
            do {
                    let decoder = JSONDecoder()
                    let stock = try decoder.decode(Root.self, from: value)
                    print(stock.quote)
            } catch let error {
                print(error)
            }
        case .error(let error):
            print(error)
        }
    }
    print("Finished")
}


struct Root : Decodable {
    
    let quote : stock
    
    struct stock: Decodable {
        var name: String
        var symbol: String
        var sector: String
        var price: Double
        
        private enum CodingKeys: String, CodingKey {
            case name = "companyName"
            case symbol
            case sector
            case price = "latestPrice"
        }
    }
}

/*
let json = """
{"quote":{"symbol":"AAPL","companyName":"Apple Inc.","primaryExchange":"Nasdaq Global Select","sector":"Technology","calculationPrice":"close","open":154.22,"openTime":1547735400372,"close":155.86,"closeTime":1547758800470,"high":157.66,"low":153.26,"latestPrice":155.86,"latestSource":"Close","latestTime":"January 17, 2019","latestUpdate":1547758800470,"latestVolume":29604499,"iexRealtimePrice":null,"iexRealtimeSize":null,"iexLastUpdated":null,"delayedPrice":155.86,"delayedPriceTime":1547758800470,"extendedPrice":155.84,"extendedChange":-0.02,"extendedChangePercent":-0.00013,"extendedPriceTime":1547762369585,"previousClose":154.94,"change":0.92,"changePercent":0.00594,"iexMarketPercent":null,"iexVolume":null,"avgTotalVolume":45782276,"iexBidPrice":null,"iexBidSize":null,"iexAskPrice":null,"iexAskSize":null,"marketCap":737187095580,"peRatio":13.13,"week52High":233.47,"week52Low":142,"ytdChange":-0.007104579533941071},"bids":[],"asks":[],"systemEvent":{}}
""".data(using: .utf8)!

let decoder = JSONDecoder()
let products = try decoder.decode(Root.self, from: json)
//for product in products {
    print(products.quote.name)
//}
*/

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
