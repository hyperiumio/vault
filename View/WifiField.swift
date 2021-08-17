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

#if DEBUG
struct WifiFieldPreview: PreviewProvider {
    
    static let item = WifiItem(name: "foo", password: "bar")
    
    static var previews: some View {
        List {
            WifiField(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            WifiField(item)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }

    
}
#endif
