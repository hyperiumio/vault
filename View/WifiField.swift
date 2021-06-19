import Pasteboard
import SwiftUI

struct WifiField: View {
    
    private let name: String?
    private let password: String?
    @State private var passwordIsVisisble = false
    
    init(name: String?, password: String?) {
        self.name = name
        self.password = password
    }
    
    var body: some View {
        Group {
            if let name = name {
                Button {
                    Pasteboard.general.string = name
                } label: {
                    Field(.name) {
                        Text(name)
                    }
                }
            }
            
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
            }
        }
        .buttonStyle(.message(.copied))
        .toggleStyle(.secure)
    }
    
}

#if DEBUG
struct WifiFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            WifiField(name: "foo", password: "bar")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }

    
}
#endif
