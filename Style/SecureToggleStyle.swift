import Pasteboard
import SwiftUI

struct SecureToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            configuration.label
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: .eyeSymbol)
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

#if DEBUG
import SwiftUI

struct SecureToggleStylePreview: PreviewProvider {
    
    @State static private var isOn = true
    
    static var previews: some View {
        Toggle("foo", isOn: $isOn)
            .toggleStyle(.secure)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        Toggle("foo", isOn: $isOn)
            .toggleStyle(.secure)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
