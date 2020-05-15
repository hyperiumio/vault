import Combine
import SwiftUI
import UIKit

@UIApplicationMain
class AppController: UIResponder, UIApplicationDelegate {
    
    let preferencesStore = PreferencesStore(userDefaults: .standard)
    let contentModelContext: ContentModelContext
    var window: UIWindow?
    
    private var launchStateSubscription: AnyCancellable?
    
    override init() {
        self.contentModelContext = ContentModelContext(masterKeyUrl: .masterKey, vaultUrl: .vault, preferencesStore: preferencesStore)
        
        super.init()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        launchStateSubscription = FileManager.default.fileExistsPublisher(url: .masterKey)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] masterKeyExists in
            guard let self = self else {
                return
            }
            
            let initialState = masterKeyExists ? ContentModel.InitialState.locked : ContentModel.InitialState.setup
            let contentModel = ContentModel(initialState: initialState, context: self.contentModelContext)
            let contentView = ContentView(model: contentModel)
            
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
