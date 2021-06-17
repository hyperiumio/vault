import SwiftUI

struct EditCustomView<S>: View where S: CustomStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        SecureItemView {
            EditSecureItemField(.description, text: $state.description) {
                TextField(.value, text: $state.value)
            }
        }
    }
    
}

#if DEBUG
struct EditCustomViewPreview: PreviewProvider {
    
    static let state = CustomStateStub()
    
    static var previews: some View {
        List {
            EditCustomView(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
