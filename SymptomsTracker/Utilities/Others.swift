import Foundation
import SwiftUI

func openAppleHealth() {
    openUrl("x-apple-health://browse");
}

private func openUrl(_ urlString: String) {
    guard let url = URL(string: urlString) else {
        return
    }
    
    UIApplication.shared.open(url)
}

func removeDuplicates<T>(_ array: [T]) -> [T] {
    let orderedSet: NSMutableOrderedSet = []
    var modifiedArray = [T]()
    
    orderedSet.addObjects(from: array)
    
    for i in 0..<orderedSet.count {
        modifiedArray.append(orderedSet[i] as! T)
    }
    
    return modifiedArray
}

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
