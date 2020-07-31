import SwiftUI

extension Color {
    
    static let appBlue = Color("AppBlue")
    static let appGray = Color("AppGray")
    static let appGreen = Color("AppGreen")
    static let appRed = Color("AppRed")
    static let appYellow = Color("AppYellow")
    
}

#if canImport(AppKit)
import AppKit

extension Color {
    
    static let textFieldBackground = Self(.textBackgroundColor)
    
}

#endif

#if canImport(UIKit)
import UIKit

extension Color {
    
    static let textFieldBackground = Self(.secondarySystemBackground)
    
}

#endif
