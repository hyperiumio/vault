import Model
import Resource
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
            List {
                Section {
                    SecureItemView(state.primaryItem)
                } header: {
                    TextField(Localized.title, text: $state.title)
                        .textCase(.none)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Localized.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    SecureItemTypeView(state.primaryItem.secureItem.value.secureItemType)
                        .foregroundStyle(.secondary)
                        .imageScale(.medium)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(Localized.save) {
                        Task {
                            await state.save()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
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
                TextField(Localized.title, text: $state.title)
                    .textCase(.none)
            }
        }
        .frame(minWidth: 400, minHeight: 300)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(Localized.cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(Localized.save) {
                    Task {
                        await state.save()
                        presentationMode.wrappedValue.dismiss()
                    }
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
