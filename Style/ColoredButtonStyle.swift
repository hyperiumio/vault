import SwiftUI

struct ColoredButtonStyle: ButtonStyle {
    
    private let color: Color
    private let size: Size
    private let expansion: Expansion
    
    init(_ color: Color, size: Size, expansion: Expansion) {
        self.color = color
        self.size = size
        self.expansion = expansion
    }
    
    func makeBody(configuration: Configuration) -> some View {
        Group {
            switch (size, expansion) {
            case (.small, .fit):
                configuration.label
                    .font(.subheadline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .foregroundColor(.white)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            case (.small, .fill):
                configuration.label
                    .font(.subheadline)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            case (.large, .fit):
                configuration.label
                    .font(.headline)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .foregroundColor(.white)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            case (.large, .fill):
                configuration.label
                    .font(.headline)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
    }
    
}

extension ColoredButtonStyle {
    
    enum Size {
        
        case small
        case large
        
    }
    
    enum Expansion {
        
        case fit
        case fill
        
    }
    
}
