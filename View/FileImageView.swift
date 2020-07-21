import SwiftUI

#if canImport(AppKit)
import AppKit

struct FileImageView: View {
    
    let data: Data
    
    @ViewBuilder var body: some View {
        if let nativeImage = NSImage(data: data) {
            Image(nsImage: nativeImage)
        } else {
            Text("?")
        }
    }
    
}
#endif

#if canImport(UIKit)
import UIKit

struct FileImageView: View {
    
    let data: Data

    @ViewBuilder var body: some View {
        if let nativeImage = UIImage(data: data) {
            Image(uiImage: nativeImage)
        } else {
            Text("?")
        }
    }
    
}
#endif
