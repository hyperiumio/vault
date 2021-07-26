import Model
import Resource
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
                Label(Localized.login, systemImage: SFSymbol.person)
            case .password:
                Label(Localized.password, systemImage: SFSymbol.key)
            case .wifi:
                Label(Localized.wifi, systemImage: SFSymbol.wifi)
            case .note:
                Label(Localized.note, systemImage: SFSymbol.noteText)
            case .bankCard:
                Label(Localized.bankCard, systemImage: SFSymbol.creditcard)
            case .bankAccount:
                Label(Localized.bankAccount, systemImage: SFSymbol.dollarsign)
            case .custom:
                Label(Localized.custom, systemImage: SFSymbol.scribbleVariable)
            case .file:
                Label(Localized.file, systemImage: SFSymbol.paperclip)
            }
        }
        .symbolVariant(.fill)
        .symbolRenderingMode(.hierarchical)
        .labelStyle(.titleAndIcon)
    }
    
}
