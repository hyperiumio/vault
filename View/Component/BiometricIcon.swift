import SwiftUI

struct BiometricIcon: View {
    
    let biometricType: BiometricType

    
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
    
    init(_ biometricType: BiometricType) {
        self.biometricType = biometricType
    }
    
}

#if DEBUG
struct BiometricIconPreviews: PreviewProvider {
    
    static var previews: some View {
        BiometricIcon(.faceID)
    }
    
}
#endif
