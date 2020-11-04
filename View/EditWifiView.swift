import Localization
import SwiftUI

#if os(iOS)
struct EditWifiView<Model>: View where Model: WifiModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        EditSecureItemTextField(LocalizedString.name, placeholder: LocalizedString.name, text: $model.name)
            .keyboardType(.asciiCapable)
        
        EditSecureItemSecureTextField(LocalizedString.password, placeholder: LocalizedString.password, text: $model.password, generatorAvailable: true)
    }
    
}
#endif

#if os(iOS) && DEBUG
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
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
