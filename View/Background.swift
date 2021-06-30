import SwiftUI

struct Background: View {
    
    #if os(iOS)
    var body: some View {
        Color(uiColor: .systemBackground)
            .ignoresSafeArea()
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        Color(nsColor: .windowBackgroundColor)
            .ignoresSafeArea()
    }
    #endif
    
}
