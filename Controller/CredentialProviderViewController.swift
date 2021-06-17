import AuthenticationServices
import Combine
import Crypto
import Foundation
import Preferences
import SwiftUI

class CredentialProviderViewController: ASCredentialProviderViewController {

    private lazy var mainState: QuickAccessState<QuickAccessDependency>? = {
        /*
        guard let appContainerDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: .appGroup) else {
            return nil
        }
        guard let userDefaults = UserDefaults(suiteName: .appGroup) else {
            return nil
        }
        let preferences = Preferences(using: userDefaults)
        guard let activeStoreID = preferences.value.activeStoreID else {
            return nil
        }
        
        let containerDirectory = appContainerDirectory.appendingPathComponent("Library", isDirectory: true).appendingPathComponent("Application Support", isDirectory: true).appendingPathComponent("Vaults", isDirectory: true)
        let keychain = Keychain(accessGroup: .appGroup)
        let mainStateDependency = QuickAccessDependency(preferences: preferences, keychain: keychain)
        let state = QuickAccessState(dependency: mainStateDependency, containerDirectory: containerDirectory, storeID: activeStoreID)
        
        didSelectSubscription = state.done
            .sink { [extensionContext] item in
                let passwordCredential = ASPasswordCredential(user: item.username, password: item.password)
                extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
            }
        
        return state
         */
        fatalError()
    }()
    
    private var didSelectSubscription: AnyCancellable?
    
    #if os(iOS)
    override func loadView() {
        view = UIView()
        
        let rootView = Group {
            if let state = mainState {
                QuickAccessView(state) {
                    self.extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue))
                }
            } else {
                Text("Error")
            }
        }
        let hostingController = UIHostingController(rootView: rootView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        hostingController.didMove(toParent: self)
    }
    #endif
    
    #if os(macOS)
    override func loadView() {
        let rootView = Group {
            if let state = mainState {
                QuickAccessView(state) {
                    self.extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue))
                }
            } else {
                Text("Error")
            }
        }
        
        view = NSHostingView(rootView: rootView)
    }
    #endif
    
}

private extension String {
    
    #if os(iOS)
    static var appGroup: Self { "group.io.hyperium.vault" }
    #endif

    #if os(macOS)
    static var appGroup: Self { "HX3QTQLX65.io.hyperium.vault" }
    #endif
    
}
