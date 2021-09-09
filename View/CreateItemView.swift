import Model
import SwiftUI

struct CreateItemView: View {
    
    @ObservedObject private var state: CreateItemState
    @Environment(\.presentationMode) private var presentationMode
    
    init(_ state: CreateItemState) {
        self.state = state
    }
    
    #if os(iOS)
    var body: some View {
        NavigationView {
            Form {
                Section {
                    SecureItemView(state.primaryItem)
                } header: {
                    TextField(.title, text: $state.title)
                        .textCase(.none)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    SecureItemTypeView(state.primaryItem.secureItem.value.secureItemType)
                        .labelStyle(.titleAndIcon)
                        .foregroundStyle(.secondary)
                        .imageScale(.medium)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(.save) {
                        state.save()
                    }
                    .disabled(state.title.isEmpty)
                }
            }
        }
        .disabled(state.isUserInputDisabled)
        .onChange(of: state.status) { status in
            switch status {
            case .didSave:
                presentationMode.wrappedValue.dismiss()
            case .readyToSave, .saving, .savingDidFail:
                return
            }
        }
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        List {
            Section {
                SecureItemView(state.primaryItem)
            } header: {
                TextField(.title, text: $state.title)
                    .textCase(.none)
            }
        }
        .frame(minWidth: 400, minHeight: 300)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(.cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(.save) {
                    state.save()
                }
            }
        }
    }
    #endif
    
}

#if DEBUG
struct CreateItemViewPreview: PreviewProvider {
    
    static let state = CreateItemState(itemType: .login, service: .stub)
    
    static var previews: some View {
        CreateItemView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        CreateItemView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif

private extension CreateItemState {
    
    var isUserInputDisabled: Bool {
        switch status {
        case .readyToSave, .savingDidFail:
            return false
        case .saving, .didSave:
            return true
        }
    }
    
}
