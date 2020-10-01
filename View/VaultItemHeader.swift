import Pasteboard
import SwiftUI

struct VaultItemDisplayHeader: View {
    
    private let text: String
    private let typeIdentifier: SecureItemTypeIdentifier
    
    init(_ text: String, typeIdentifier: SecureItemTypeIdentifier) {
        self.text = text
        self.typeIdentifier = typeIdentifier
    }
    
    var body: some View {
        SecureItemButton {
            Pasteboard.general.string = text
        } content: {
            Text(text)
                .font(Font.largeTitle.bold())
                .padding()
        }
    }
    
}

struct VaultItemEditHeader: View {
    
    private let title: String
    private let text: Binding<String>
    private let typeIdentifier: SecureItemTypeIdentifier
    
    init(_ title: String, text: Binding<String>, typeIdentifier: SecureItemTypeIdentifier) {
        self.title = title
        self.text = text
        self.typeIdentifier = typeIdentifier
    }
    
    var body: some View {
        TextField(title, text: text)
            .font(Font.largeTitle.bold())
            .padding()
    }
    
}
