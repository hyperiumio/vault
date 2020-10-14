import SwiftUI

struct ColoredButtonStyle: ButtonStyle {
    
    let color: Color
    let size: Size
    
    init(_ color: Color, size: Size) {
        self.color = color
        self.size = size
    }
    
    func makeBody(configuration: Configuration) -> some View {
        switch size {
        case .small:
            return configuration.label
                .font(.body)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .foregroundColor(.white)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        case .large:
            return configuration.label
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .foregroundColor(.white)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
    
}

extension ColoredButtonStyle {
    
    enum Size {
        
        case small
        case large
        
    }
    
}
