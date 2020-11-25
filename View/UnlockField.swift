import SwiftUI

struct UnlockField: View {
    
    private let title: String
    private let text: Binding<String>
    private let action: () -> Void
    
    init(_ title: String, text: Binding<String>, action: @escaping () -> Void) {
        self.title = title
        self.text = text
        self.action = action
    }
    
    #if os(iOS)
    var body: some View {
        HStack(spacing: 0) {
            SecureField(title, text: text)
                .font(.system(size: 20))
                .disableAutocorrection(true)
                .frame(height: 44)
                .padding(.horizontal, 20)
                .background(Color.textFieldBackground)
            
            Button(action: action) {
                Image.lock
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.accentColor)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        HStack(spacing: 0) {
            NativeTextField(title: title, text: text, isSecure: true, textStyle: .headline, alignment: .center, action: action)
            
            Button(action: action) {
                Image.lock
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.accentColor)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .background(Color.textFieldBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
    #endif
    
}

#if DEBUG
struct UnlockFieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        Group {
            UnlockField("foo", text: $text) {}
                .preferredColorScheme(.light)
            
            UnlockField("foo", text: $text) {}
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
