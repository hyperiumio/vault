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
            Label {
                Text(text)
                    .font(.title3)
            } icon: {
                typeIdentifier.image
                    .imageScale(.large)
                    .foregroundColor(typeIdentifier.color)
            }
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
        Label {
            TextField(title, text: text)
                .font(.title3)
        } icon: {
            typeIdentifier.image
                .imageScale(.large)
                .foregroundColor(typeIdentifier.color)
        }
    }
    
}
