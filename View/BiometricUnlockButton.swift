import SwiftUI

struct BiometricUnlockButton: View {
    
    let biometricType: BiometricType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            BiometricIcon(biometricType)
        }
        .frame(width: 40, height: 40)
        .buttonStyle(PlainButtonStyle())
    }
    
    init(_ biometricType: BiometricType, action: @escaping () -> Void) {
        self.biometricType = biometricType
        self.action = action
    }
    
}
