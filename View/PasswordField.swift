import Model
import Pasteboard
import SwiftUI

struct PasswordField: View {
    
    private let item: PasswordItem
    @State private var passwordIsVisisble = false
    
    init(_ item: PasswordItem) {
        self.item = item
    }
    
    var body: some View {
        if let password = item.password {
            Toggle(isOn: $passwordIsVisisble) {
                Button {
                    Pasteboard.general.string = password
                } label: {
                    Field(.password) {
                        ConfidentialText(password, isVisible: passwordIsVisisble)
                    }
                }
                .buttonStyle(.message(.copied))
            }
            .toggleStyle(.secure)
        }
    }

}

#if DEBUG
struct PasswordFieldPreview: PreviewProvider {
    
    static let item = PasswordItem(password: "foo")
    
    static var previews: some View {
        List {
            PasswordField(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            PasswordField(item)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
