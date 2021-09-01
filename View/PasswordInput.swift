import SwiftUI

struct PasswordInput: View {
    
    private let title: LocalizedStringKey
    private let password: Binding<String>
    
    init(_ title: LocalizedStringKey, password: Binding<String>) {
        self.title = title
        self.password = password
    }
    
    var body: some View {
        SecureField(title, text: password, prompt: nil)
            .font(.title2)
            .padding()
            .textFieldStyle(.plain)
    }
    
}

#if DEBUG
struct PasswordInputPreview: PreviewProvider {
    
    @State static var password = ""
    
    static var previews: some View {
        PasswordInput(.password, password: $password)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        PasswordInput(.password, password: $password)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
