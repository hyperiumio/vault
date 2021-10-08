import Model
import SwiftUI

struct StoreInfoSettingsView: View {
    
    @ObservedObject private var state: StoreInfoSettingsState
    
    init(_ state: StoreInfoSettingsState) {
        self.state = state
    }
    
    var body: some View {
        List {
            Section {
                InfoField {
                    Text(.created)
                } value: {
                    Text(state.storeInfo.created, format: .dateTime)
                }
            }
            
            Section(.numberOfItem) {
                InfoField(.login, count: state.storeInfo.loginItemCount)
                
                InfoField(.password, count: state.storeInfo.passwordItemCount)
                
                InfoField(.wifi, count: state.storeInfo.wifiItemCount)
                
                InfoField(.note, count: state.storeInfo.noteItemCount)
                
                InfoField(.bankCard, count: state.storeInfo.bankCardItemCount)
                
                InfoField(.bankAccount, count: state.storeInfo.bankAccountItemCount)
                
                InfoField(.custom, count: state.storeInfo.customItemCount)
                
                InfoField(.file, count: state.storeInfo.fileItemCount)
            }
        }
        .navigationTitle(.storeInfos)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
    
}

extension InfoField where Title == SecureItemTypeView, Value == Text {
    
    init(_ secureItemType: SecureItemType, count: Int) {
        self = InfoField {
            SecureItemTypeView(secureItemType)
        } value: {
            Text(count, format: .number)
        }
    }
    
}

/*
#if DEBUG
struct StoreInfoSettingsViewPreview: PreviewProvider {
    
    static let state = StoreInfoSettingsState(service: .stub)
    
    static var previews: some View {
        StoreInfoSettingsView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        StoreInfoSettingsView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
*/
