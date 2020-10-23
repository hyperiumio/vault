import Localization
import SwiftUI

struct SecureItemTypeView: View {
    
    private let type: SecureItemType
    
    init(_ type: SecureItemType) {
        self.type = type
    }
    
    var body: some View {
        HStack {
            switch type {
            case .password:
                Image.password
            case .login:
                Image.login
            case .file:
                Image.file
            case .note:
                Image.note
            case .bankCard:
                Image.bankCard
            case .wifi:
                Image.wifi
            case .bankAccount:
                Image.bankAccount
            case .custom:
                Image.custom
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
