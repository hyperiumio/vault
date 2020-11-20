import SwiftUI

struct BiometricUnlockButton: View {
    
    private let biometryType: BiometryType
    private let action: () -> Void
    
    init(_ biometryType: BiometryType, action: @escaping () -> Void) {
        self.biometryType = biometryType
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Self.image(for: biometryType)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .frame(width: 40, height: 40)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}

private extension BiometricUnlockButton {
    
    static func image(for biometryType: BiometryType) -> Image {
        switch biometryType {
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
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
