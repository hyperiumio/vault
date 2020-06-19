import Combine
import Crypto
import Preferences
import SwiftUI
import UIKit

@UIApplicationMain
class ApplicationController: UIResponder {
    
    let applicationWindowController = ApplicationWindowController(preferencesManager: .shared, biometricKeychain: .shared)

}

extension ApplicationController: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        applicationWindowController.load()
        return true
    }
    
}
