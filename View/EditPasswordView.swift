import Localization
import SwiftUI

struct EditPasswordView<Model>: View where Model: PasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemSecureTextEditField(LocalizedString.password, placeholder: LocalizedString.password, text: $model.password, generatorAvailable: true)
    }

}
