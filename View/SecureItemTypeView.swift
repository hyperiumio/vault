import Localization
import SwiftUI

struct SecureItemTypeView: View {
    
    let type: SecureItemType
    
    init(_ type: SecureItemType) {
        self.type = type
    }
    
    var body: some View {
        HStack {
            switch type {
            case .password:
                Image.password.foregroundColor(Color.appGray)
            case .login:
                Image.login.foregroundColor(Color.appBlue)
            case .file:
                Image.file.foregroundColor(Color.appPink)
            case .note:
                Image.note.foregroundColor(Color.appYellow)
            case .bankCard:
                Image.bankCard.foregroundColor(Color.appPurple)
            case .wifi:
                Image.wifi.foregroundColor(Color.appTeal)
            case .bankAccount:
                Image.bankAccount.foregroundColor(Color.appGreen)
            case .custom:
                Image.custom.foregroundColor(Color.appRed)
            }
            
            switch type {
            case .password:
                Text(LocalizedString.password)
            case .login:
                Text(LocalizedString.login)
            case .file:
                Text(LocalizedString.file)
            case .note:
                Text(LocalizedString.note)
            case .bankCard:
                Text(LocalizedString.bankCard)
            case .wifi:
                Text(LocalizedString.wifi)
            case .bankAccount:
                Text(LocalizedString.bankAccount)
            case .custom:
                Text(LocalizedString.customItem)
            }
        }
    }
    
}
