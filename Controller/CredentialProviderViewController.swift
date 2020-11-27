import AuthenticationServices
import Combine
import Crypto
import Identifier
import SwiftUI

class CredentialProviderViewController: ASCredentialProviderViewController {

    private var sub: AnyCancellable?
    
    #if os(iOS)
    override func loadView() {
        view = UIView()
        
        let rootView = CredentialProviderView {
            self.extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue))
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
