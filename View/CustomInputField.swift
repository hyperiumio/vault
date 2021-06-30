import SwiftUI

struct CustomInputField: View {
    
    @ObservedObject private var state: CustomState
    
    init(_ state: CustomState) {
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
