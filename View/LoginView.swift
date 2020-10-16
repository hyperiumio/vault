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
        SecureItemTextEditField(LocalizedString.username, placeholder: LocalizedString.usernameOrEmail, text: $model.username)
            .keyboardType(.emailAddress)
            .textContentType(.username)
        
        SecureItemSecureTextEditField(LocalizedString.password, placeholder: LocalizedString.password, text: $model.password, generatorAvailable: true)
        
        SecureItemTextEditField(LocalizedString.url, placeholder: LocalizedString.exampleURL, text: $model.url)
            .keyboardType(.URL)
            .textContentType(.URL)
    }
    
}
