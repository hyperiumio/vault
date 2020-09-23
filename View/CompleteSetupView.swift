import SwiftUI

struct CompleteSetupView<Model>: View where Model: CompleteSetupModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Text("foo")
    }
    
}
