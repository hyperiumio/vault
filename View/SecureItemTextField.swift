import SwiftUI
import Pasteboard

struct SecureItemTextDisplayField: View {
    
    private let title: String
    private let text: String
    
    init(_ title: String, text: String) {
        self.title = title
        self.text = text
    }
    
    var body: some View {
        SecureItemButton {
            Pasteboard.general.string = text
        } content: {
            SecureItemDisplayField(title) {
                Text(text)
            }
        }
    }
    
}

struct SecureItemTextEditField: View {
    
    private let title: String
    private let text: Binding<String>
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self.text = text
    }
    
    var body: some View {
        SecureItemDisplayField(title) {
            TextField(title, text: text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
    
}
