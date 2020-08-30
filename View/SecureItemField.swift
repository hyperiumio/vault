import SwiftUI

struct SecureItemField<Content>: View where Content: View {
    
    private let style: Style
    private let content: Content
    
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.style = .display(title: title)
        self.content = content()
    }
    
    init(_ title: String, text: Binding<String>, isEditable: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.style = .edit(title: title, text: text, isEditable: isEditable)
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Group {
                switch style {
                case .display(let text):
                    Text(text)
                case .edit(let title, let text, let isEditable):
                    TextField(title, text: text)
                        .disabled(!isEditable.wrappedValue)
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondaryLabel)
            
            content
        }
    }
    
}

extension SecureItemField {
    
    enum Style {
        
        case display(title: String)
        case edit(title: String, text: Binding<String>, isEditable: Binding<Bool>)
        
    }
    
}
