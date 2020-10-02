#if canImport(AppKit)
import AppKit

public class Pasteboard {
    
    private let systemPasteboard: NSPasteboard
    
    public var string: String? {
        get {
            systemPasteboard.string(forType: .string)
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
#endif

#if canImport(UIKit)
import UIKit

public class Pasteboard {
    
    private let systemPasteboard: UIPasteboard
    
    public var string: String? {
        get {
            systemPasteboard.string
        }
        set(string) {
            systemPasteboard.string = string
        }
    }
    
    private init(systemPasteboard: UIPasteboard) {
        self.systemPasteboard = systemPasteboard
    }
    
}
#endif

extension Pasteboard {
    
    public static let general = Pasteboard(systemPasteboard: .general)
    
}
