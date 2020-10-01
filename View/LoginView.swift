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
            
            SecureItemDivider()
            
            SecureItemSecureTextDisplayField(LocalizedString.password, text: model.password)
            
            SecureItemDivider()
            
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
            
            SecureItemDivider()
            
            VStack(spacing: 0) {
                SecureItemSecureTextEditField(LocalizedString.password, text: $model.password)
                
                PasswordGeneratorView(action: model.generatePassword)
                    .padding()
            }
            
            SecureItemDivider()
            
            SecureItemTextEditField(LocalizedString.url, text: $model.url)
        }
    }
    
}
