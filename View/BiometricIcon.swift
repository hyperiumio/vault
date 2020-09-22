import SwiftUI

struct BiometricIcon: View {
    
    private let biometricType: BiometricType
    
    var body: some View {
        switch biometricType {
        case .touchID:
            Image.touchID
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .faceID:
            Image.faceID
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    init(_ biometricType: BiometricType) {
        self.biometricType = biometricType
    }
    
}
