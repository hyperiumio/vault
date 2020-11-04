import SwiftUI

extension Color {
    
    static let appBlue = Color.accentColor
    static let appGray = Color("AppGray")
    static let appGreen = Color("AppGreen")
    static let appPink = Color("AppPink")
    static let appPurple = Color("AppPurple")
    static let appRed = Color("AppRed")
    static let appTeal = Color("AppTeal")
    static let appYellow = Color("AppYellow")
    
}

#if canImport(AppKit)
import AppKit

extension Color {
    
    static let systemBackground = Self(.textBackgroundColor)
    static let textFieldBackground = Self(.textBackgroundColor)
    static let label = Self(.labelColor)
    static let secondaryLabel = Self(.secondaryLabelColor)
    static let tertiaryLabel = Self(.tertiaryLabelColor)
    static let quaternaryLabel = Self(.quaternaryLabelColor)
    
}

#endif

#if canImport(UIKit)
import UIKit

extension Color {
    
    static let systemBackground = Self(.systemBackground)
    static let textFieldBackground = Self(.secondarySystemBackground)
    static let label = Self(.label)
    static let secondaryLabel = Self(.secondaryLabel)
    static let tertiaryLabel = Self(.tertiaryLabel)
    static let quaternaryLabel = Self(.quaternaryLabel)
    
}
#endif
