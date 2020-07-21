import SwiftUI

struct BiometricUnlockButton: View {
    
    let biometricType: BiometricType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: biometricType.imageSystemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
        }
        .buttonStyle(buttonStyle)
        .padding()
    }
    
    var buttonStyle: some PrimitiveButtonStyle { PlainButtonStyle() }
    
}

extension BiometricUnlockButton {
    
    enum BiometricType {
        
        case touchID
        case faceID
        
        fileprivate var imageSystemName: String {
            switch self {
            case .touchID:
                return "touchid"
            case .faceID:
                return "faceid"
            }
        }
        
    }
    
}
