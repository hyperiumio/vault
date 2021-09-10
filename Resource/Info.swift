#if os(iOS)
import UIKit

enum Info {
    
    static var systemName: String {
        UIDevice.current.systemName
    }
    
    static var appName: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    static var version: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    static var build: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
    
}
#endif
