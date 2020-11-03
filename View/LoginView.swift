import Localization
import SwiftUI

struct LoginView: View {
    
    private let item: LoginItem
    
    init(_ item: LoginItem) {
        self.item = item
    }
    
    var body: some View {
        if let username = item.username {
            SecureItemTextDisplayField(LocalizedString.username, text: username)
        }
        
        if let password = item.password {
            SecureItemSecureTextDisplayField(LocalizedString.password, text: password)
        }
        
        if let url = item.url {
            SecureItemTextDisplayField(LocalizedString.url, text: url)
        }
    }
    
}
