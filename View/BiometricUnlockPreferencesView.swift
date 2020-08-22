import Localization
import SwiftUI

#if os(macOS)
struct BiometricUnlockPreferencesView<Model>: View where Model: BiometricUnlockPreferencesModelRepresentable {
    
    @ObservedObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
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
            //.listStyle(GroupedListStyle())
            //.navigationBarTitleDisplayMode(.inline)
            .navigationTitle(model.biometricType.localizedTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .disabled(model.userInputDisabled)
    }
    
    private var headerImage: some View {
        HStack {
            Spacer()
            
            BiometryIcon(model.biometricType)
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
    
}
#endif

#if os(iOS)
struct BiometricUnlockPreferencesView<Model>: View where Model: BiometricUnlockPreferencesModelRepresentable {
    
    @ObservedObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
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
            .listStyle(GroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(model.biometricType.localizedTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .disabled(model.userInputDisabled)
    }
    
    private var headerImage: some View {
        HStack {
            Spacer()
            
            BiometryIcon(model.biometricType)
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
    
}
#endif

private extension BiometricType {
    
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
    
}

#if DEBUG
import Combine

class BiometricUnlockPreferencesModelStub: BiometricUnlockPreferencesModelRepresentable {
    
    var password = ""
    var status = BiometricUnlockPreferencesModel.Status.biometricActivationFailed
    var userInputDisabled: Bool { status == .loading }
    let biometricType = BiometricType.touchID
    
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
