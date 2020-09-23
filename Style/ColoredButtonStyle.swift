import SwiftUI

struct ColoredButtonStyle: ButtonStyle {
    
    let color: Color
    
    init(_ color: Color) {
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .foregroundColor(.white)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
    
}
