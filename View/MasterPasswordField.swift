import SwiftUI

struct MasterPasswordField: View {
    
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
                .font(.title2)
                .submitLabel(.continue)
                .padding()
            
            Button(action: action) {
                Image(systemName: .lock)
                    .imageScale(.large)
                    .foregroundColor(.white)
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal)
                    .background(Color.accentColor)
            }
            .buttonStyle(.plain)
        }
        .frame(maxHeight: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .clipShape(.buttonShape)
    }
    
}

private extension Shape where Self == RoundedRectangle {
    
    static var buttonShape: Self {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
    }
    
}
