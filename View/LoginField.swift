import Pasteboard
import SwiftUI

struct LoginField: View {
    
    private let username: String?
    private let password: String?
    private let url: String?
    @State private var passwordIsVisisble = false
    
    init(username: String?, password: String?, url: String?) {
        self.username = username
        self.password = password
        self.url = url
    }
    
    var body: some View {
        Group {
            if let username = username {
                Button {
                    Pasteboard.general.string = username
                } label: {
                    Field(.username) {
                        Text(username)
                    }
                }
            }
            
            if let password = password {
                Toggle(isOn: $passwordIsVisisble) {
                    Button {
                        Pasteboard.general.string = password
                    } label: {
                        Field(.password) {
                            ConfidentialText(password, isVisible: passwordIsVisisble)
                        }
                    }
                }
            }
            
            if let url = url {
                Button {
                    Pasteboard.general.string = url
                } label: {
                    Field(.url) {
                        Text(url)
                    }
                }
            }
        }
        .buttonStyle(.message(.copied))
        .toggleStyle(.secure)
    }
    
}
