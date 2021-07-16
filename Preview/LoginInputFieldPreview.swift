#if DEBUG
import SwiftUI

struct LoginInputFieldPreview: PreviewProvider {
    
    static let loginService = LoginService()
    static let loginState = LoginItemState(dependency: loginService)
    
    static var previews: some View {
        List {
            LoginInputField(loginState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            LoginInputField(loginState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}

extension LoginInputFieldPreview {
    
    struct LoginService: LoginItemDependency {
        
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
