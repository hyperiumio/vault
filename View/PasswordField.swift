import Pasteboard
import SwiftUI

struct PasswordField: View {
    
    private let password: String?
    @State private var passwordIsVisisble = false
    
    init(password: String?) {
        self.password = password
    }
    
    var body: some View {
        if let password = password {
            Toggle(isOn: $passwordIsVisisble) {
                Button {
                    Pasteboard.general.string = password
                } label: {
                    Field(.password) {
                        Text(passwordIsVisisble ? password : "••••••••")
                            .font(.body.monospaced())
                    }
                }
            }
            .toggleStyle(.secure)
        }
    }

}

#if DEBUG
struct PasswordFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            PasswordField(password: "foo")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
