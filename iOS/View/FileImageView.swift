import SwiftUI
import UIKit

struct FileImageView: View {
    
    let data: Data

    var body: some View {
        guard let nativeImage = UIImage(data: data) else {
            return Text("?").eraseToAnyView()
        }
        
        return Image(uiImage: nativeImage).eraseToAnyView()
    }
    
}
