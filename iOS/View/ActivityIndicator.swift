import SwiftUI
import UIKit

struct ActivityIndicator: UIViewRepresentable {
    
    let isAnimating: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        return indicator
    }
    
    func updateUIView(_ indicator: UIActivityIndicatorView, context: Context) {
        if isAnimating {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
    
}
