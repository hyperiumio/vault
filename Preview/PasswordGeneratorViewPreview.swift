#if DEBUG
import SwiftUI

struct PasswordGeneratorViewPreview: PreviewProvider {
    
    static let passwordGeneratorService = PasswordGeneratorService()
    static let state = PasswordGeneratorState(dependency: passwordGeneratorService)
    
    static var previews: some View {
        PasswordGeneratorView(state: state) { password in
            print(password)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        PasswordGeneratorView(state: state) { password in
            print(password)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}

extension PasswordGeneratorViewPreview {
    
    struct PasswordGeneratorService: PasswordGeneratorDependency {
        
        func password(length: Int, digit: Bool, symbol: Bool) async -> String {
            "foo"
        }
    
    }
    
}
#endif
