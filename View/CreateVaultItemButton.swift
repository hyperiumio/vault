import SwiftUI

struct CreateVaultItemButton<Label>: View where Label: View {
    
    private let action: (SecureItemType) -> Void
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
                ForEach(SecureItemType.allCases) { typeIdentifier in
                    Button {
                        
                        action(typeIdentifier)
                        selectionPresented = false
                    } label: {
                        SwiftUI.Label {
                            Text(typeIdentifier.name)
                        } icon: {
                            typeIdentifier.image
                                .foregroundColor(typeIdentifier.color)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
    
    init(action: @escaping (SecureItemType) -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }
    
}
