import SwiftUI

struct CreateVaultItemButton: View {
    
    let action: (SecureItemType) -> Void
    
    var body: some View {
        return MenuButton(.addItem) {
            MenuItem(titleKey: .login) {
                self.action(.login)
            }
            
            MenuItem(titleKey: .password) {
                self.action(.password)
            }
            
            MenuItem(titleKey: .file) {
                self.action(.file)
            }
        }
        .menuButtonStyle(BorderlessButtonMenuButtonStyle())
    }
    
}
