import AuthenticationServices
import Combine
import Crypto
import Identifier
import Preferences
import SwiftUI

class CredentialProviderViewController: ASCredentialProviderViewController {

    private let mainModel: QuickAccessModel<QuickAccessDependency>? = {
        guard let appContainerDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Identifier.appGroup) else {
            return nil
        }
        guard let preferences = Preferences(appGroup: Identifier.appGroup) else {
            return nil
        }
        guard let activeVaultID = preferences.value.activeVaultIdentifier else {
            return nil
        }
        
        let vaultContainerDirectory = appContainerDirectory.appendingPathComponent("Library", isDirectory: true).appendingPathComponent("Application Support", isDirectory: true).appendingPathComponent("Vaults", isDirectory: true)
        let keychain = Keychain(accessGroup: Identifier.appGroup, identifier: Identifier.appBundleID)
        let mainModelDependency = QuickAccessDependency(vaultContainerDirectory: vaultContainerDirectory, preferences: preferences, keychain: keychain)
        return QuickAccessModel(dependency: mainModelDependency, vaultID: activeVaultID)
    }()
    
    #if os(iOS)
    override func loadView() {
        view = UIView()
        
        let rootView = Group {
            if let model = mainModel {
                QuickAccessView(model) {
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
        let rootView = CredentialProviderView { [extensionContext] in
            let error = NSError(domain: ASExtensionError.errorDomain, code: ASExtensionError.Code.userCanceled.rawValue)
            extensionContext.cancelRequest(withError: error)
        }
        
        view = NSHostingView(rootView: rootView)
    }
    #endif
    
    /*
     Prepare your UI to list available credentials for the user to choose from. The items in
     'serviceIdentifiers' describe the service the user is logging in to, so your extension can
     prioritize the most relevant credentials in the list.
    */
    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {}

    func passwordSelected(_ sender: AnyObject?) {
        let passwordCredential = ASPasswordCredential(user: "j_appleseed", password: "apple1234")
        extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
    }
    
}
