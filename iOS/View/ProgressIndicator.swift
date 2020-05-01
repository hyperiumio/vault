import SwiftUI
import UIKit

struct ProgressIndicator: UIViewRepresentable {
    
    let value: Double
    
    func makeUIView(context: Context) -> UIProgressView {
        return UIProgressView()
    }
    
    func updateUIView(_ progressView: UIProgressView, context: Context) {
        progressView.progress = Float(value).clamped(to: 0 ... 1)
    }
    
}
