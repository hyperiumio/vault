import Localization
import SwiftUI

struct PasswordView<Model>: View where Model: PasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemContainer {
            SecureItemSecureTextField(LocalizedString.password, text: model.password)
        }
    }

}
