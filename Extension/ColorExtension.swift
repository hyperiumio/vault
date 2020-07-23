import SwiftUI

#if canImport(AppKit)
import AppKit

extension Color {
    
    public static let textFieldBackground = Self(.textBackgroundColor)
    
}

#endif

#if canImport(UIKit)
import UIKit

extension Color {
    
    public static let textFieldBackground = Self(.secondarySystemBackground)
    
}

#endif
