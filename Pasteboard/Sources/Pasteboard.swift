#if os(iOS)
import UIKit

public typealias Pasteboard = UIPasteboard
#endif

#if os(macOS)
import AppKit

public typealias Pasteboard = NSPasteboard

public extension Pasteboard {
    
    var string: String? {
        get {
            string(forType: .string)
        }
        set(string) {
            clearContents()
            guard let string = string else {
                return
            }
            setString(string, forType: .string)
        }
    }
    
}
#endif
