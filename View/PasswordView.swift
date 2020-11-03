import Localization
import SwiftUI

struct PasswordDisplayView: View {
    
    private let item: PasswordItem
    
    init(_ item: PasswordItem) {
        self.item = item
    }
    
    var body: some View {
        if let password = item.password {
            SecureItemSecureTextDisplayField(LocalizedString.password, text: password)
        }
    }

}
