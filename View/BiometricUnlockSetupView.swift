import SwiftUI

struct BiometricUnlockSetupView<Model>: View where Model: BiometricUnlockSetupModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Text("foo")
    }
    
}
