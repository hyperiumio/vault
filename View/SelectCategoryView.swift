import Asset
import SwiftUI

struct SelectCategoryView: View {
    
    private let action: (Selection) -> Void
    
    init(action: @escaping (Selection) -> Void) {
        self.action = action
    }
    
    
    var body: some View {
        List {
            Button {
                action(.login)
            } label: {
                Label(Localized.login, systemImage: SFSymbol.person)
            }
            
            Button {
                action(.password)
            } label: {
                Label(Localized.password, systemImage: SFSymbol.key)
            }
            
            Button {
                action(.wifi)
            } label: {
                Label(Localized.wifi, systemImage: SFSymbol.wifi)
            }
            
            Button {
                action(.note)
            } label: {
                Label(Localized.note, systemImage: SFSymbol.noteText)
            }
            
            Button {
                action(.bankCard)
            } label: {
                Label(Localized.bankCard, systemImage: SFSymbol.creditcard)
            }
            
            Button {
                action(.bankAccount)
            } label: {
                Label(Localized.bankAccount, systemImage: SFSymbol.dollarsign)
            }
            
            Button {
                action(.file)
            } label: {
                Label(Localized.file, systemImage: SFSymbol.doc)
            }
            
            Button {
                action(.custom)
            } label: {
                Label(Localized.custom, systemImage: SFSymbol.scribbleVariable)
            }
        }
    }
    
}

extension SelectCategoryView {
    
    enum Selection {
        
        case login
        case password
        case wifi
        case note
        case bankCard
        case bankAccount
        case file
        case custom
        
    }
    
}
