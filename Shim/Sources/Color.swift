import SwiftUI

public extension Color {
    
    #if os(iOS)
    static var background: Self {
        Color(uiColor: .systemBackground)
    }
    #endif

    #if os(macOS)
    static var background: Self {
        Color(nsColor: .windowBackgroundColor)
    }
    #endif
    
}
