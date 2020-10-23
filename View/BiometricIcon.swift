import SwiftUI

struct BiometricIcon: View {
    
    private let image: Image
    
    init(_ type: BiometricType) {
        switch type {
        case .touchID:
            self.image = .touchID
        case .faceID:
            self.image = .faceID
        }
    }
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
}
