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
                        ConfidentialText(password, isVisible: passwordIsVisisble)
                    }
                }
                .buttonStyle(.message(.copied))
            }
            .toggleStyle(.secure)
        }
    }

}
