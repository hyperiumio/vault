import Model
import Pasteboard
import SwiftUI

struct WifiField: View {
    
    private let item: WifiItem
    @State private var passwordIsVisisble = false
    
    init(_ item: WifiItem) {
        self.item = item
    }
    
    var body: some View {
        Group {
            if let name = item.name {
                Button {
                    Pasteboard.general.string = name
                } label: {
                    Field(.name) {
                        Text(name)
                    }
                }
            }
            
            if let password = item.password {
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
        }
        .buttonStyle(.message(.copied))
        .toggleStyle(.secure)
    }
    
}
