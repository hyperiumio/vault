import Pasteboard
import SwiftUI

struct VaultItemDisplayHeader: View {
    
    private let text: String
    private let type: SecureItemType
    
    init(_ text: String, type: SecureItemType) {
        self.text = text
        self.type = type
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
    private let itemType: SecureItemType
    
    init(_ title: String, text: Binding<String>, itemType: SecureItemType) {
        self.title = title
        self.text = text
        self.itemType = itemType
    }
    
    var body: some View {
        TextField(title, text: text)
            .font(Font.largeTitle.bold())
            .padding()
    }
    
}
