import Pasteboard
import SwiftUI

struct SecureToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            configuration.label
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: .eye)
                .symbolVariant(configuration.isOn ? .none : .slash)
                .foregroundColor(.accentColor)
                .padding()
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
    
}

extension ToggleStyle where Self == SecureToggleStyle {
    
    static var secure: Self {
        Self()
    }
    
}
