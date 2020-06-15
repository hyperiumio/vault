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
        
        launchStateSubscription = FileManager.default.fileExistsPublisher(url: .masterKey)
            .map { fileExists in
                return (fileExists ? .locked : .setup) as ContentModel.InitialState
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] initialState in
                guard let self = self else {
                    return
                }
                
                let contentModelContext = ContentModelContext(masterKeyUrl: .masterKey, vaultUrl: .vault, preferencesManager: .shared)
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
