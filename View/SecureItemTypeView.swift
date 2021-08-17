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
                Label(.login, systemImage: .personSymbol)
            case .password:
                Label(.password, systemImage: .keySymbol)
            case .wifi:
                Label(.wifi, systemImage: .wifiSymbol)
            case .note:
                Label(.note, systemImage: .noteTextSymbol)
            case .bankCard:
                Label(.bankCard, systemImage: .creditcardSymbol)
            case .bankAccount:
                Label(.bankAccount, systemImage: .dollarsignSymbol)
            case .custom:
                Label(.custom, systemImage: .scribbleVariableSymbol)
            case .file:
                Label(.file, systemImage: .paperclipSymbol)
            }
        }
        .symbolVariant(.fill)
        .symbolRenderingMode(.hierarchical)
    }
    
}
