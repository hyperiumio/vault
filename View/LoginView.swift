import Localization
import Pasteboard
import SwiftUI

struct LoginDisplayView<Model>: View where Model: LoginModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            SecureItemTextDisplayField(LocalizedString.user, text: model.username)
            
            SecureItemSecureTextDisplayField(LocalizedString.password, text: model.password)
            
            SecureItemTextDisplayField(LocalizedString.url, text: model.url)
        }
    }
    
}

struct LoginEditView<Model>: View where Model: LoginModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            SecureItemTextEditField(LocalizedString.user, text: $model.username)
            
            VStack(spacing: 20) {
                SecureItemSecureTextEditField(LocalizedString.password, text: $model.password)
                
                PasswordGeneratorView(action: model.generatePassword)
            }
            
            SecureItemTextEditField(LocalizedString.url, text: $model.url)
        }
    }
    
}
