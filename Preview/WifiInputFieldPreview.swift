#if DEBUG
import SwiftUI

struct WifiInputFieldPreview: PreviewProvider {
    
    static let service = WifiService()
    static let wifiState = WifiItemState(dependency: service)
    
    static var previews: some View {
        List {
            WifiInputField(wifiState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            WifiInputField(wifiState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}

extension WifiInputFieldPreview {
    
    struct WifiService: WifiItemDependency {
        
        var passwordGeneratorDependency: PasswordGeneratorDependency {
            PasswordGeneratorService()
        }
        
    }
    
    struct PasswordGeneratorService: PasswordGeneratorDependency {
        
        func password(length: Int, digit: Bool, symbol: Bool) async -> String {
            "foo"
        }
        
    }
    
}
#endif
