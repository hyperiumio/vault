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
        }
    }
    
}

extension ToggleStyle where Self == SecureToggleStyle {
    
    static var secure: Self {
        Self()
    }
    
}

#if DEBUG
struct ItemSecureFieldPreview: PreviewProvider {
    
    @State static private var isOn = true
    
    static var previews: some View {
        Toggle("foo", isOn: $isOn)
            .toggleStyle(.secure)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
