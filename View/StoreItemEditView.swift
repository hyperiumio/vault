import Resource
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
                SecureItemView(state.primaryItem)
            } header: {
                TextField(Localized.title, text: $state.title)
                    .textCase(.none)
            }
            
            Section {
                Button(Localized.deleteItem, role: .destructive) {
                    Task {
                        await state.delete()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(Localized.cancel, action: cancel)
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(Localized.save) {
                    Task {
                        try await state.save()
                    }
                }
            }
        }
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        #endif
    }
    
}

#if DEBUG
struct StoreItemEditViewPreview: PreviewProvider {
    
    static let state = StoreItemEditState(editing: AppServiceStub.storeItem, service: .stub)
    
    static var previews: some View {
        NavigationView {
            StoreItemEditView(state) {
                print("cancel")
            }
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            StoreItemEditView(state) {
                print("cancel")
            }
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }

    
}
#endif
