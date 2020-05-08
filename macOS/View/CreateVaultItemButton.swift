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
            
            MenuItem(titleKey: .note) {
                self.action(.note)
            }
            
            MenuItem(titleKey: .bankCard) {
                self.action(.bankCard)
            }
            
            MenuItem(titleKey: .wifi) {
                self.action(.wifi)
            }
            
            MenuItem(titleKey: .bankAccount) {
                self.action(.bankAccount)
            }
        }
        .menuButtonStyle(BorderlessButtonMenuButtonStyle())
    }
    
}
