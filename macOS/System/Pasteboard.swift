import AppKit

class Pasteboard {
    
    private let systemPasteboard: NSPasteboard
    
    var string: String? {
        get {
            return systemPasteboard.string(forType: .string)
        }
        set(string) {
            systemPasteboard.clearContents()
            
            guard let string = string else {
                return
            }
            systemPasteboard.setString(string, forType: .string)
        }
    }
    
    private init(systemPasteboard: NSPasteboard) {
        self.systemPasteboard = systemPasteboard
    }
    
}

extension Pasteboard {
    
    static let general = Pasteboard(systemPasteboard: .general)
    
}
