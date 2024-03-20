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
