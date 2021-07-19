#if DEBUG
import SwiftUI

struct PasswordInputFieldPreview: PreviewProvider {
    
    static let service = PasswordService()
    static let passwordState = PasswordItemState(dependency: service)
    
    static var previews: some View {
        List {
            PasswordInputField(passwordState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            PasswordInputField(passwordState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}

extension PasswordInputFieldPreview {
    
    actor PasswordService: PasswordItemDependency {
        
        nonisolated func passwordGeneratorDependency() -> PasswordGeneratorDependency {
            PasswordGeneratorService()
        }
        
    }
    
    actor PasswordGeneratorService: PasswordGeneratorDependency {
        
        func password(length: Int, digit: Bool, symbol: Bool) async -> String {
            "foo"
        }
        
    }
    
}
#endif
