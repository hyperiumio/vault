import Asset
import SwiftUI

struct CustomInputField: View {
    
    @ObservedObject private var state: CustomItemState
    
    init(_ state: CustomItemState) {
        self.state = state
    }
    
    var body: some View {
        Field {
            TextField(Localized.description, text: $state.description)
        } content: {
            TextField(Localized.value, text: $state.value)
        }
    }
    
}
