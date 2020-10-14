import Localization
import Pasteboard
import SwiftUI

struct LoginView<Model>: View where Model: LoginModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextDisplayField(LocalizedString.username, text: model.username)
        
        SecureItemSecureTextDisplayField(LocalizedString.password, text: model.password)
        
        SecureItemTextDisplayField(LocalizedString.url, text: model.url)
    }
    
}

struct EditLoginView<Model>: View where Model: LoginModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextEditField(LocalizedString.username, placeholder: LocalizedString.enterUsername, text: $model.username)
            .keyboardType(.emailAddress)
            .textContentType(.username)
        
        VStack(spacing: 20) {
            SecureItemSecureTextEditField(LocalizedString.password, placeholder: LocalizedString.enterPassword, text: $model.password)
                .keyboardType(.asciiCapable)
                .textContentType(.newPassword)
            
            GeneratePasswordView(action: model.generatePassword)
        }
        
        SecureItemTextEditField(LocalizedString.url, placeholder: LocalizedString.enterURL, text: $model.url)
            .keyboardType(.URL)
            .textContentType(.URL)
    }
    
}
