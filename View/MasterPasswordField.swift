import Resource
import SwiftUI

struct MasterPasswordField: View {
    
    private let title: String
    private let text: Binding<String>
    private let action: () -> Void
    
    init(_ title: String, text: Binding<String>, action: @escaping () -> Void) {
        self.title = title
        self.text = text
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 0) {
            SecureField(Localized.title, text: text, prompt: nil)
                .font(.title2)
                .textFieldStyle(.plain)
                .padding()
                .submitLabel(.continue)
            
            Button(action: action) {
                Image(systemName: SFSymbol.lock)
                    .imageScale(.large)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.accentColor)
                    .frame(maxHeight: .infinity)
            }
            .buttonStyle(.plain)
        }
        .frame(maxHeight: .infinity)
        .background(.quaternary)
        .fixedSize(horizontal: false, vertical: true)
        .clipShape(.buttonShape)
    }
    
}

private extension Shape where Self == RoundedRectangle {
    
    static var buttonShape: Self {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
    }
    
}

#if DEBUG
struct MasterPasswordFieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        MasterPasswordField("foo", text: $text) {
            print("lock")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        MasterPasswordField("foo", text: $text) {
            print("lock")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
