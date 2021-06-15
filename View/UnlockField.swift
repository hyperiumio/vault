import SwiftUI

struct UnlockField: View {
    
    private let title: LocalizedStringKey
    private let text: Binding<String>
    private let action: () -> Void
    
    init(_ title: LocalizedStringKey, text: Binding<String>, action: @escaping () -> Void) {
        self.title = title
        self.text = text
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 0) {
            SecureField(.title, text: text, prompt: nil)
                .submitLabel(.continue)
                .padding()
            
            Button(action: action) {
                Image(systemName: .lock)
                    .foregroundColor(.white)
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal)
                    .background(Color.accentColor)
                    
            }
        }
        .buttonStyle(.plain)
        .frame(maxHeight: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .font(.title2)
        .imageScale(.large)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    
}

#if DEBUG
struct UnlockFieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        UnlockField("foo", text: $text) {}
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
