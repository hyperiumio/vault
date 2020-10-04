#if canImport(AppKit)
import AppKit

public class Pasteboard {
    
    private let systemPasteboard: SystemPasteboardRepresentable
    
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
    
    init(systemPasteboard: SystemPasteboardRepresentable) {
        self.systemPasteboard = systemPasteboard
    }
    
}

extension Pasteboard {
    
    public static let general = Pasteboard(systemPasteboard: NSPasteboard.general)
    
}

protocol SystemPasteboardRepresentable: class {
    
    func string(forType dataType: NSPasteboard.PasteboardType) -> String?
    @discardableResult func clearContents() -> Int
    @discardableResult func setString(_ string: String, forType dataType: NSPasteboard.PasteboardType) -> Bool
    
}

extension NSPasteboard: SystemPasteboardRepresentable {}
#endif

#if canImport(UIKit)
import UIKit

public typealias Pasteboard = UIPasteboard
#endif
