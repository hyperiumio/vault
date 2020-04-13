import AppKit
import SwiftUI

struct ProgressIndicator: NSViewRepresentable {
    
    let value: Double
    
    func makeNSView(context: Context) -> NSProgressIndicator {
        let indicator = NSProgressIndicator()
        indicator.style = .bar
        indicator.isIndeterminate = false
        return indicator
    }
    
    func updateNSView(_ indicator: NSProgressIndicator, context: Context) {
        indicator.doubleValue = value.clamped(to: 0 ... 1) * 100
    }
    
}
