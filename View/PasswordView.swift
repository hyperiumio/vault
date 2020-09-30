import Localization
import SwiftUI

struct PasswordDisplayView<Model>: View where Model: PasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemSecureTextDisplayField(LocalizedString.password, text: model.password)
    }

}

struct PasswordEditView<Model>: View where Model: PasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        VStack(spacing: 20) {
            SecureItemSecureTextEditField(LocalizedString.password, text: $model.password)
            
            PasswordGeneratorView(action: model.generatePassword)
        }
    }

}
