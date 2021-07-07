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
                Label(.login, systemImage: SFSymbol.person)
            }
            
            Button {
                action(.password)
            } label: {
                Label(.password, systemImage: SFSymbol.key)
            }
            
            Button {
                action(.wifi)
            } label: {
                Label(.wifi, systemImage: SFSymbol.wifi)
            }
            
            Button {
                action(.note)
            } label: {
                Label(.note, systemImage: SFSymbol.noteText)
            }
            
            Button {
                action(.bankCard)
            } label: {
                Label(.bankCard, systemImage: SFSymbol.creditcard)
            }
            
            Button {
                action(.bankAccount)
            } label: {
                Label(.bankAccount, systemImage: SFSymbol.dollarsign)
            }
            
            Button {
                action(.file)
            } label: {
                Label(.file, systemImage: SFSymbol.doc)
            }
            
            Button {
                action(.custom)
            } label: {
                Label(.custom, systemImage: SFSymbol.scribbleVariable)
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
