import SwiftUI

struct MessageButtonStyle: ButtonStyle {
    
    let textKey: LocalizedStringKey
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .overlay {
                Text(textKey)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .font(.subheadline)
                    .opacity(configuration.isPressed ? 1 : 0)
            }
            
    }
    
}

extension ButtonStyle where Self == MessageButtonStyle {
    
    static func message(_ textKey: LocalizedStringKey) -> Self {
        Self(textKey: textKey)
    }
    
}
