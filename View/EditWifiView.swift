import SwiftUI

struct EditWifiView<Model>: View where Model: WifiModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        EditItemTextField(.name, placeholder: .name, text: $model.name)
            .keyboardType(.asciiCapable)
        
        EditItemSecureField(.password, placeholder: .password, text: $model.password, generatorAvailable: true)
    }
    
}

#if DEBUG
struct EditWifiViewPreview: PreviewProvider {
    
    static let model = WifiModelStub()
    
    static var previews: some View {
        List {
            EditWifiView(model)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
