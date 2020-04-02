import AppKit
import SwiftUI

struct ActivityIndicator: NSViewRepresentable {
    
    let isAnimating: Bool
    
    func makeNSView(context: Context) -> NSProgressIndicator {
        let indicator = NSProgressIndicator()
        indicator.style = .spinning
        indicator.isDisplayedWhenStopped = false
        return indicator
    }
    
    func updateNSView(_ indicator: NSProgressIndicator, context: Context) {
        if isAnimating {
            indicator.startAnimation(nil)
        } else {
            indicator.stopAnimation(nil)
        }
    }
    
}
