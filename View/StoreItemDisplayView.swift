import SwiftUI

struct StoreItemDisplayView: View {
    
    private let title: String
    private let primaryItem: SecureItemField.Value
    private let secondaryItems: [SecureItemField.Value]
    private let created: Date?
    private let modified: Date?
    private let done: () -> Void
    
    init(_ title: String, primaryItem: SecureItemField.Value, secondaryItems: [SecureItemField.Value], created: Date?, modified: Date?, done: @escaping () -> Void) {
        self.title = title
        self.primaryItem = primaryItem
        self.secondaryItems = secondaryItems
        self.created = created
        self.modified = modified
        self.done = done
    }
    
    var body: some View {
        List {
            Section {
                SecureItemField(primaryItem)
            } header: {
                Text(title)
                    .textCase(.none)
            } footer: {
                DateFooter(created: created, modified: modified)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(.edit, action: done)
            }
        }
    }
    
}

/*
private extension StoreItemDisplayView {
    
    @MainActor
    var secureItemFieldValue: SecureItemField.Value {
        switch self {
        case .login(let state):
            return .login(username: state.username, password: state.password, url: state.url)
        case .password(let state):
            return .password(password: state.password)
        case .file(let state):
            return .file(data: state.data, typeIdentifier: state.typeIdentifier)
        case .note(let state):
            return .note(text: state.text)
        case .bankCard(let state):
            return .bankCard(name: state.name, vendor: nil, number: state.number, expirationDate: state.expirationDate, pin: state.pin)
        case .wifi(let state):
            return .wifi(name: state.name, password: state.password)
        case .bankAccount(let state):
            return .bankAccount(accountHolder: state.accountHolder, iban: state.iban, bic: state.bic)
        case .custom(let state):
            return .custom(description: state.description, value: state.value)
        }
    }
    
}
*/
