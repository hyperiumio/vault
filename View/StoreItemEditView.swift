import SwiftUI

struct StoreItemEditView: View {
    
    @ObservedObject private var state: StoreItemEditState
    private let cancel: () -> Void
    
    init(_ state: StoreItemEditState, cancel: @escaping () -> Void) {
        self.state = state
        self.cancel = cancel
    }
    
    var body: some View {
        List {
            Section {
                SecureItemInputField(state.primaryItem)
            } header: {
                TextField(.title, text: $state.title)
                    .textCase(.none)
            }
            
            Section {
                Button(.deleteItem, role: .destructive) {
                    async {
                        await state.delete()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(.cancel, action: cancel)
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(.save) {
                    async {
                        try await state.save()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
}
