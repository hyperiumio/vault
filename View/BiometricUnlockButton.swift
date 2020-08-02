import SwiftUI

struct BiometricUnlockButton: View {
    
    let biometricType: BiometricType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            BiometryIcon(biometricType)
        }
        .frame(width: 40, height: 40)
        .buttonStyle(buttonStyle)
        .padding()
    }
    
    var buttonStyle: some PrimitiveButtonStyle { PlainButtonStyle() }
    
}

#if DEBUG
struct BiometricUnlockButtonPreview: PreviewProvider {
    
    static var previews: some View {
        BiometricUnlockButton(biometricType: .faceID, action: {})
            .preferredColorScheme(.dark)
    }
    
}
#endif
