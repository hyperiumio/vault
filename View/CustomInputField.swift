import SwiftUI

struct CustomInputField<CustomInputState>: View where CustomInputState: CustomStateRepresentable {
    
    @ObservedObject private var state: CustomInputState
    
    init(_ state: CustomInputState) {
        self.state = state
    }
    
    var body: some View {
        Field {
            TextField(.description, text: $state.description)
        } content: {
            TextField(.value, text: $state.value)
        }
    }
    
}

#if DEBUG
struct CustomInputFieldPreview: PreviewProvider {
    
    static let state = CustomStateStub()
    
    static var previews: some View {
        List {
            CustomInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
