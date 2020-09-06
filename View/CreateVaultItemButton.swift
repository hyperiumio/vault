import SwiftUI

struct CreateVaultItemButton<Label>: View where Label: View {
    
    private let action: (SecureItemTypeIdentifier) -> Void
    private let label: Label
    
    @State private var selectionPresented = false
    
    var body: some View {
        Button {
            selectionPresented = true
        } label: {
            label
        }
        .buttonStyle(PlainButtonStyle())
        .popover(isPresented: $selectionPresented) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(SecureItemTypeIdentifier.allCases) { typeIdentifier in
                    Button {
                        action(typeIdentifier)
                    } label: {
                        SwiftUI.Label {
                            Text(typeIdentifier.name)
                        } icon: {
                            Image(typeIdentifier)
                                .foregroundColor(Color(typeIdentifier))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
    
    init(action: @escaping (SecureItemTypeIdentifier) -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }
    
}
