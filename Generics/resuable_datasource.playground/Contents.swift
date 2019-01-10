
import UIKit

struct Message {
    var title: String
    var preview: String
}

/*
 extension InboxViewController: UITableViewDataSource {
 func tableView(_ tableView: UITableView,
 numberOfRowsInSection section: Int) -> Int {
 return messages.count
 }
 
 func tableView(_ tableView: UITableView,
 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let message = messages[indexPath.row]
 let cell = tableView.dequeueReusableCell(
 withIdentifier: "message",
 for: indexPath
 )
 
 cell.textLabel?.text = message.title
 cell.detailTextLabel?.text = message.preview
 
 return cell
 }
 }
*/
class MessageListDataSource: NSObject, UITableViewDataSource {
    // We keep this public and mutable, to enable our data
    // source to be updated as new data comes in.
    var messages: [Message]
    
    init(messages: [Message]) {
        self.messages = messages
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "message",
            for: indexPath
        )
        
        cell.textLabel?.text = message.title
        cell.detailTextLabel?.text = message.preview
        
        return cell
    }
}


// Generalizing

class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    
    var models: [Model]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )
        
        cellConfigurator(model, cell)
        
        return cell
    }
}

func messagesDidLoad(_ messages: [Message]) {
    let dataSource = TableViewDataSource(
        models: messages,
        reuseIdentifier: "message"
    ) { message, cell in
        cell.textLabel?.text = message.title
        cell.detailTextLabel?.text = message.preview
    }
    
    // We also need to keep a strong reference to the data source,
    // since UITableView only uses a weak reference for it.
//    self.dataSource = dataSource
//    tableView.dataSource = dataSource
}

/*
 extension TableViewDataSource where Model == Message {
 static func make(for messages: [Message],
 reuseIdentifier: String = "message") -> TableViewDataSource {
 return TableViewDataSource(
 models: messages,
 reuseIdentifier: reuseIdentifier
 ) { (message, cell) in
 cell.textLabel?.text = message.title
 cell.detailTextLabel?.text = message.preview
 }
 }
 }
*/
