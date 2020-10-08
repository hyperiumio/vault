import Localization
import Pasteboard
import SwiftUI

struct LoginDisplayView<Model>: View where Model: LoginModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextDisplayField(LocalizedString.user, text: model.username)
        
        SecureItemSecureTextDisplayField(LocalizedString.password, text: model.password)
        
        SecureItemTextDisplayField(LocalizedString.url, text: model.url)
    }
    
}

struct LoginEditView<Model>: View where Model: LoginModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextEditField(LocalizedString.user, text: $model.username)
            .keyboardType(.emailAddress)
            .textContentType(.username)
        
        VStack(spacing: 0) {
            SecureItemSecureTextEditField(LocalizedString.password, text: $model.password)
                .keyboardType(.asciiCapable)
                .textContentType(.newPassword)
            
            PasswordGeneratorView(action: model.generatePassword)
                .padding()
        }
        
        SecureItemTextEditField(LocalizedString.url, text: $model.url)
            .keyboardType(.URL)
            .textContentType(.URL)
    }
    
}
