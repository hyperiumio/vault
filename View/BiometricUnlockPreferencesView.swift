import Localization
import SwiftUI

#if os(macOS)
struct BiometricUnlockPreferencesView<Model>: View where Model: BiometricUnlockPreferencesModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: model.biometricType.systemImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)

            Text(model.biometricType.localizedDescription)
            
            SecureField(LocalizedString.masterPassword, text: $model.password)
            
            switch model.status {
            case .none, .loading:
                EmptyView()
            case .biometricActivationFailed:
                ErrorBadge(model.biometricType.activationFailedError)
            case .invalidPassword:
                ErrorBadge(LocalizedString.wrongPassword)
            }
            
            HStack {
                Spacer()
                
                Button(LocalizedString.cancel, action: model.cancel)
                    .keyboardShortcut(.cancelAction)
                
                Button(LocalizedString.enable, action: model.enabledBiometricUnlock)
                    .keyboardShortcut(.defaultAction)
            }
        }
        .disabled(model.userInputDisabled)
        .frame(width: 300)
        .padding()
    }
    
    private var errorMessage: some View {
        HStack {
            Spacer()
            
            switch model.status {
            case .none, .loading:
                EmptyView()
            case .biometricActivationFailed:
                ErrorBadge(model.biometricType.activationFailedError)
            case .invalidPassword:
                ErrorBadge(LocalizedString.wrongPassword)
            }
            
            Spacer()
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
    
    private var cancelButton: some View {
        Button(LocalizedString.cancel, action: model.cancel)
    }
    
}
#endif

#if os(iOS)
struct BiometricUnlockPreferencesView<Model>: View where Model: BiometricUnlockPreferencesModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: headerImage, footer: enableBiometricUnlockDescription) {
                    SecureField(LocalizedString.masterPassword, text: $model.password)
                }
                
                Section(footer: errorMessage) {
                    HStack {
                        Spacer()
                        
                        Button(LocalizedString.enable, action: model.enabledBiometricUnlock)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(model.biometricType.localizedTitle, displayMode: .inline)
            .navigationBarItems(trailing: cancelButton)
        }
        .disabled(model.userInputDisabled)
    }
    
    private var headerImage: some View {
        HStack {
            Spacer()
            
            Image(systemName: model.biometricType.systemImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .padding(.top, 40)
                .padding(.bottom, 20)
            
            Spacer()
        }
    }
    
    private var enableBiometricUnlockDescription: some View {
        Text(model.biometricType.localizedDescription)
    }
    
    private var errorMessage: some View {
        HStack {
            Spacer()
            
            switch model.status {
            case .none, .loading:
                EmptyView()
            case .biometricActivationFailed:
                ErrorBadge(model.biometricType.activationFailedError)
            case .invalidPassword:
                ErrorBadge(LocalizedString.wrongPassword)
            }
            
            Spacer()
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
    
    private var cancelButton: some View {
        Button(LocalizedString.cancel, action: model.cancel)
    }
    
}
#endif

private extension BiometricUnlockPreferencesModel.BiometryType {
    
    var localizedTitle: String {
        switch self {
        case .touchID:
            return LocalizedString.touchID
        case .faceID:
            return LocalizedString.faceID
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .touchID:
            return LocalizedString.enableTouchIDUnlockDescription
        case .faceID:
            return LocalizedString.enableFaceIDUnlockDescription
        }
    }
    
    var activationFailedError: String {
        switch self {
        case .touchID:
            return LocalizedString.touchIDActivationFailed
        case .faceID:
            return LocalizedString.faceIDActivationFailed
        }
    }
    
    var systemImageName: String {
        switch self {
        case .touchID:
            return "touchid"
        case .faceID:
            return "faceid"
        }
    }
    
}

#if DEBUG
import Combine

class BiometricUnlockPreferencesModelStub: BiometricUnlockPreferencesModelRepresentable {
    
    var password = ""
    var status = BiometricUnlockPreferencesModel.Status.biometricActivationFailed
    var userInputDisabled: Bool { status == .loading }
    let biometricType = BiometricUnlockPreferencesModel.BiometryType.touchID
    
    func cancel() {}
    func enabledBiometricUnlock() {}
    
}

struct BiometricUnlockPreferencesViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            BiometricUnlockPreferencesView(model: BiometricUnlockPreferencesModelStub())
                .preferredColorScheme(.dark)
        }
    }
    
}
#endif
