import SwiftUI
import Store

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

extension Color {
    
    init(_ secureItemType: SecureItem.TypeIdentifier) {
        switch secureItemType {
        case .password:
            self = .appGray
        case .login:
            self = .appBlue
        case .file:
            self = .appPink
        case .note:
            self = .appYellow
        case .bankCard:
            self = .appPurple
        case .wifi:
            self = .appTeal
        case .bankAccount:
            self = .appGreen
        case .custom:
            self = .appRed
        }
    }
    
}

#if canImport(AppKit)
import AppKit

extension Color {
    
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
    
    static let textFieldBackground = Self(.secondarySystemBackground)
    static let label = Self(.label)
    static let secondaryLabel = Self(.secondaryLabel)
    static let tertiaryLabel = Self(.tertiaryLabel)
    static let quaternaryLabel = Self(.quaternaryLabel)
    
}

#endif
