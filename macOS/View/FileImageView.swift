import AppKit
import SwiftUI

struct FileImageView: View {
    
    let data: Data

    var body: some View {
        guard let nativeImage = NSImage(data: data) else {
            return Text("?").eraseToAnyView()
        }
        
        return Image(nsImage: nativeImage).eraseToAnyView()
    }
    
}
