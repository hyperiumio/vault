import SwiftUI

struct BiometryIcon: View {
    
    let biometricType: BiometricType
    
    init(_ biometricType: BiometricType) {
        self.biometricType = biometricType
    }
    
    var body: some View {
        switch biometricType {
        case .touchID:
            Image.touchID
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
        case .faceID:
            Image.faceID
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
        }
    }
    
}
