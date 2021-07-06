import SwiftUI

struct StoreItemDetailView: View {
    
    @ObservedObject private var state: StoreItemDetailState
    
    init(_ state: StoreItemDetailState) {
        self.state = state
    }
    
    var body: some View {
        Group {
            switch state.status {
            case .initialized:
                Background()
            case .loading:
                ProgressView()
            case .display(let storeItem):
                StoreItemDisplayView(storeItem.name, primaryItem: storeItem.primaryItem.value, secondaryItems: storeItem.secondaryItems.map(\.value), created: storeItem.created, modified: storeItem.modified) {
                    state.edit()
                }
            case .edit(let editState):
                StoreItemEditView(editState) {
                    state.cancelEdit()
                }
            case .loadingFailed:
                FailureView(.loadingVaultFailed) {
                    await state.load()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await state.load()
        }
    }
    
}

extension StoreItemDetailState.SecureItem {
    
    var value: SecureItemField.Value {
        switch self {
        case .password(let item):
            return .password(password: item.password)
        case .login(let item):
            return .login(username: item.username, password: item.password, url: item.url)
        case .file(let item):
            return .file(data: item.data, type: item.type)
        case .note(let item):
            return .note(text: item.text)
        case .bankCard(let item):
            return .bankCard(name: item.name, vendor: nil, number: item.number, expirationDate: item.expirationDate, pin: item.pin)
        case .wifi(let item):
            return .wifi(name: item.name, password: item.password)
        case .bankAccount(let item):
            return .bankAccount(accountHolder: item.accountHolder, iban: item.iban, bic: item.bic)
        case .custom(let item):
            return .custom(description: item.description, value: item.value)
        }
    }
    
}
