import Crypto
import SwiftUI

struct BiometricUnlockButton: View {
    
    private let biometryType: Keychain.BiometryType
    private let action: () -> Void
    
    init(_ biometryType: Keychain.BiometryType, action: @escaping () -> Void) {
        self.biometryType = biometryType
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Self.image(for: biometryType)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}

private extension BiometricUnlockButton {
    
    static func image(for biometryType: Keychain.BiometryType) -> Image {
        switch biometryType {
        case .touchID:
            return Image(systemName: SFSymbolName.touchid)
        case .faceID:
            return Image(systemName: SFSymbolName.faceid)
        }
    }
    
}

#if DEBUG
struct BiometricUnlockButtonPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            BiometricUnlockButton(.faceID) {}
                .preferredColorScheme(.light)
            
            BiometricUnlockButton(.touchID) {}
                .preferredColorScheme(.light)
            
            BiometricUnlockButton(.faceID) {}
                .preferredColorScheme(.dark)
            
            BiometricUnlockButton(.touchID) {}
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
