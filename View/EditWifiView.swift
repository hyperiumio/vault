import SwiftUI

#warning("Todo")
struct EditWifiView<Model>: View where Model: WifiModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(iOS)
    var body: some View {
        EditSecureItemTextField(.name, placeholder: .name, text: $model.name)
            .keyboardType(.asciiCapable)
        
        EditSecureItemSecureTextField(.password, placeholder: .password, text: $model.password, generatorAvailable: true)
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        EditSecureItemTextField(.name, placeholder: .name, text: $model.name)
        
        EditSecureItemSecureTextField(.password, placeholder: .password, text: $model.password, generatorAvailable: true)
    }
    #endif
    
}

#if DEBUG
struct EditWifiViewPreview: PreviewProvider {
    
    static let model = WifiModelStub()
    
    static var previews: some View {
        Group {
            List {
                EditWifiView(model)
            }
            .preferredColorScheme(.light)
            
            List {
                EditWifiView(model)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
