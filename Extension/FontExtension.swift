import SwiftUI

#if os(macOS)
typealias TextStyle = NSFont.TextStyle

extension NSFont.TextStyle {
    
    var lineHeight: CGFloat {
        let font = NSFont.preferredFont(forTextStyle: self)
        return NSLayoutManager().defaultLineHeight(for: font)
    }
    
}
#endif
    
#if os(iOS)
typealias TextStyle = UIFont.TextStyle

extension UIFont.TextStyle {

    var lineHeight: CGFloat {
        UIFont.preferredFont(forTextStyle: self).lineHeight
    }
    
}
#endif
