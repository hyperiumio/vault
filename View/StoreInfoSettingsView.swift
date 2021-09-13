import Model
import SwiftUI

struct StoreInfoSettingsView: View {
    
    @ObservedObject private var state: StoreInfoSettingsState
    
    init(_ state: StoreInfoSettingsState) {
        self.state = state
    }
    
    var body: some View {
        Group {
            switch state.status {
            case .initialized:
                Color.background
            case .loading:
                ProgressView()
            case let .loaded(info):
                List {
                    Section {
                        InfoField {
                            Text(.created)
                        } value: {
                            Text(info.created, format: .iso8601)
                        }
                    }
                    
                    Section(.numberOfItem) {
                        InfoField(.login, count: info.loginItemCount)
                        
                        InfoField(.password, count: info.passwordItemCount)
                        
                        InfoField(.wifi, count: info.wifiItemCount)
                        
                        InfoField(.note, count: info.noteItemCount)
                        
                        InfoField(.bankCard, count: info.bankCardItemCount)
                        
                        InfoField(.bankAccount, count: info.bankAccountItemCount)
                        
                        InfoField(.custom, count: info.customItemCount)
                        
                        InfoField(.file, count: info.fileItemCount)
                    }
                }
            case .loadingDidFail:
                FailureView(.version) {
                    state.load()
                }
            }
        }
        .navigationTitle(.storeInfos)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            state.load()
        }
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
