import SwiftUI

struct Background: View {
    
    var body: some View {
        #if os(iOS)
        Color(uiColor: .systemBackground)
            .ignoresSafeArea()
        #endif
        #if os(macOS)
        Color(nsColor: .windowBackgroundColor)
            .ignoresSafeArea()
        #endif
    }
    
}
