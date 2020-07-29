import Localization
import SwiftUI

struct PasswordDisplayView<Model>: View where Model: PasswordDisplayModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        Section {
            SecureItemDisplaySecureField(title: LocalizedString.password, content: model.password)
                .onTapGesture(perform: model.copyPasswordToPasteboard)
        }
    }
    
}

#if DEBUG
class PasswordDisplayModelStub: PasswordDisplayModelRepresentable {
    
    var password = "123abc"
    
    func copyPasswordToPasteboard() {}
    
}

struct PasswordDisplayViewPreview: PreviewProvider {
    
    static let model = PasswordDisplayModelStub()
    
    #if os(macOS)
    static var previews: some View {
        List {
            PasswordDisplayView(model: model)
        }
    }
    #endif
    
    #if os(iOS)
    static var previews: some View {
        List {
            PasswordDisplayView(model: model)
        }
        .listStyle(GroupedListStyle())
    }
    #endif
    
}
#endif
