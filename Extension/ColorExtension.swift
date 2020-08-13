import SwiftUI

extension Color {
    
    static let appBlue = Color("AppBlue")
    static let appGray = Color("AppGray")
    static let appGreen = Color("AppGreen")
    static let appRed = Color("AppRed")
    static let appYellow = Color("AppYellow")
    
}

extension Color {
    
    init(_ secureItemType: SecureItemType) {
        switch secureItemType {
        case .password:
            self = .appGray
        case .login:
            self = .appBlue
        case .file:
            self = .appGray
        case .note:
            self = .appYellow
        case .bankCard:
            self = .appGreen
        case .wifi:
            self = .appBlue
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
