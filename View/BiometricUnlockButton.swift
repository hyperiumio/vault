import SwiftUI

struct BiometricUnlockButton: View {
    
    let biometricType: BiometricType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Group {
                switch biometricType {
                case .touchID:
                    Icon(.touchID)
                case .faceID:
                    Icon(.faceID)
                }
            }
            
                
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
        
    }
    
}

#if DEBUG
struct BiometricUnlockButtonPreview: PreviewProvider {
    
    static var previews: some View {
        BiometricUnlockButton(biometricType: .faceID, action: {})
            .preferredColorScheme(.dark)
    }
    
}
#endif
