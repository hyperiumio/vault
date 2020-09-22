import Localization
import SwiftUI

struct PasswordView<Model>: View where Model: PasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
    private let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemSecureField(LocalizedString.password, text: $model.password, isEditable: isEditable)
        }
    }
    
    init(_ model: Model, isEditable: Binding<Bool>) {
        self.model = model
        self.isEditable = isEditable
    }
    
}
