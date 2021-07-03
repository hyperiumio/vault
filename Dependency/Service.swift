import Crypto
import Foundation
import Model
import Preferences

private extension String {
    
    static var vaults: Self { "Vaults" }
    
    #if os(iOS)
    static var appGroup: Self { "group.io.hyperium.vault" }
    #endif

    #if os(macOS)
    static var appGroup: Self { "HX3QTQLX65.io.hyperium.vault" }
    #endif
    
}
