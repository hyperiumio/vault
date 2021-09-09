import Model
import SwiftUI

struct SecureItemTypeView: View {
    
    private let itemType: SecureItemType
    
    init(_ itemType: SecureItemType) {
        self.itemType = itemType
    }
    
    var body: some View {
        Group {
            switch itemType {
            case .login:
                Label(.login, systemImage: SFSymbol.person.systemName)
            case .password:
                Label(.password, systemImage: SFSymbol.key.systemName)
            case .wifi:
                Label(.wifi, systemImage: SFSymbol.wifi.systemName)
            case .note:
                Label(.note, systemImage: SFSymbol.noteText.systemName)
            case .bankCard:
                Label(.bankCard, systemImage: SFSymbol.creditcard.systemName)
            case .bankAccount:
                Label(.bankAccount, systemImage: SFSymbol.dollarsign.systemName)
            case .custom:
                Label(.custom, systemImage: SFSymbol.scribbleVariable.systemName)
            case .file:
                Label(.file, systemImage: SFSymbol.paperclip.systemName)
            }
        }
        .symbolVariant(.fill)
        .symbolRenderingMode(.hierarchical)
    }
    
}
