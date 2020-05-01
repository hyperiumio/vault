import UIKit

class Pasteboard {
    
    private let systemPasteboard: UIPasteboard
    
    var string: String? {
        get {
            return systemPasteboard.string
        }
        set(string) {
            systemPasteboard.string = string
        }
    }
    
    private init(systemPasteboard: UIPasteboard) {
        self.systemPasteboard = systemPasteboard
    }
    
}

extension Pasteboard {
    
    static let general = Pasteboard(systemPasteboard: .general)
    
}
