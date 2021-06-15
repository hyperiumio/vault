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
            Image(systemName: biometryType.symbolName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
        }
        .buttonStyle(.plain)
    }
    
}

extension BiometricUnlockButton {
    
    enum BiometryType {
        
        case touchID
        case faceID
        
        var symbolName: String {
            switch self {
            case .touchID:
                return .touchid
            case .faceID:
                return .faceid
            }
        }
        
    }
    
}

#if DEBUG
struct BiometricUnlockButtonPreview: PreviewProvider {
    
    static var previews: some View {
        BiometricUnlockButton(.faceID) {}
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
