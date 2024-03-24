import Foundation
import OSLog

let logger = Logger()

func consoleLog(_ _message: String, _ data: Any? = nil) {
    var message = _message
    
    if data != nil {
        let dataString = Mirror(reflecting: data).children.compactMap { "\($0.value)" }.joined(separator: "\n")
        
        message += "\nData: \(dataString)"
    }
    
    logger.log(
        level: .debug,
        "\(message)"
    )
}
