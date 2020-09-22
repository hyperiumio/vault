import Localization
import SwiftUI

struct LoginView<Model>: View where Model: LoginModelRepresentable {
    
    @ObservedObject private var model: Model
    
    private let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemTextField(LocalizedString.user, text: $model.username, isEditable: isEditable)
            
            SecureItemSecureField(LocalizedString.password, text: $model.password, isEditable: isEditable)
            
            SecureItemTextField(LocalizedString.url, text: $model.url, isEditable: isEditable)
        }
    }
    
    init(_ model: Model, isEditable: Binding<Bool>) {
        self.model = model
        self.isEditable = isEditable
    }
    
}
