import SwiftUI

struct CredentialProviderView<Model>: View where Model: CredentialProviderModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Text("CredentialProviderView")
    }
    
}
