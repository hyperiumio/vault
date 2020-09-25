import SwiftUI

struct SecureItemTextDisplayField: View {
    
    private let title: String
    private let text: String
    
    init(_ title: String, text: String) {
        self.title = title
        self.text = text
    }
    
    var body: some View {
        SecureItemDisplayField(title) {
            Text(text)
        }
    }
    
}
