import Resource
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

#if DEBUG
struct CustomInputFieldPreview: PreviewProvider {
    
    static let customState = CustomItemState()
    
    static var previews: some View {
        List {
            CustomInputField(customState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            CustomInputField(customState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
