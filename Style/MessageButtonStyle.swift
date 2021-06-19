import SwiftUI

struct MessageButtonStyle: ButtonStyle {
    
    let text: LocalizedStringKey
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .overlay {
                Text(text)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .font(.subheadline)
                    .opacity(configuration.isPressed ? 1 : 0)
            }
            
    }
    
}

extension ButtonStyle where Self == MessageButtonStyle {
    
    static func message(_ text: LocalizedStringKey) -> Self {
        Self(text: text)
    }
    
}

#if DEBUG
struct ItemButtonPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            Button(role: nil) {
                
            } label: {
                Text("Foo")
            }
        }
        
        .buttonStyle(.message(.title))
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
