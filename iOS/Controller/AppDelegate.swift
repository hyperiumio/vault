import Combine
import Preferences
import SwiftUI
import UIKit

@UIApplicationMain
class AppController: UIResponder, UIApplicationDelegate {
    
    var contentModelContext: ContentModelContext?
    var window: UIWindow?
    
    private var launchStateSubscription: AnyCancellable?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        launchStateSubscription = LaunchState.publisher(masterKeyUrl: .masterKey)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] launchState in
                guard let self = self else {
                    return
                }
                
                let initialState = launchState.vaultExists ? ContentModel.InitialState.locked : ContentModel.InitialState.setup
                let contentModelContext = ContentModelContext(masterKeyUrl: .masterKey, vaultUrl: .vault, preferencesManager: launchState.preferencesManager)
                let contentModel = ContentModel(initialState: initialState, context: contentModelContext)
                let contentView = ContentView(model: contentModel)
                
                self.contentModelContext = contentModelContext
                self.window?.rootViewController = UIHostingController(rootView: contentView)
                self.window?.makeKeyAndVisible()
                self.launchStateSubscription = nil
            }
        
        return true
    }

}

private extension URL {
    
    static var appData: URL {
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent(Bundle.main.bundleIdentifier!, isDirectory: true)
    }
    
    static var masterKey: URL {
        return appData.appendingPathComponent("key", isDirectory: false)
    }

    static var vault: URL {
        return appData.appendingPathComponent("content", isDirectory: true)
    }
    
}
