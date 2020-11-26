import Localization
import SwiftUI

struct CredentialProviderView: View {
    
    let cancel: () -> Void
    
    #if os(iOS)
    var body: some View {
        NavigationView {
            Text("CredentialProviderView")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(LocalizedString.cancel) {
                          cancel()
                        }
                    }
                }
        }
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        VStack {
            Text("CredentialProviderView")
            
            Button(LocalizedString.cancel) {
              cancel()
            }
        }
    }
    #endif
    
}
