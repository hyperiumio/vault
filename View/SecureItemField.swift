import SwiftUI

struct SecureItemDisplayField<Content>: View where Content: View {
    
    private let title: String
    private let content: Content
    
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondaryLabel)
            
            content
        }
    }
    
}

struct SecureItemEditField<Content>: View where Content: View {
    
    private let title: String
    private let text: Binding<String>
    private let content: Content
    
    init(_ title: String, text: Binding<String>, @ViewBuilder content: () -> Content) {
        self.title = title
        self.text = text
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            TextField(title, text: text)
                .font(.subheadline)
                .foregroundColor(.secondaryLabel)
            
            content
        }
    }
    
}
