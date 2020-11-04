import Localization
import SwiftUI

// TODO: cleanup

#if os(iOS)
struct BiometricUnlockPreferencesView<Model>: View where Model: BiometricUnlockPreferencesModelRepresentable {
    
    @ObservedObject private var model: Model
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    SecureField(LocalizedString.masterPassword, text: $model.password)
                } header: {
                    Header(biometryType: model.biometryType)
                } footer: {
                    Text(model.enterMasterPasswordDescription)
                }
                
                Section {
                    HStack {
                        Spacer()
                        
                        Button(LocalizedString.enable, action: model.enabledBiometricUnlock)
                        
                        Spacer()
                    }
                } footer: {
                    ErrorMessage(status: model.status, biometryType: model.biometryType)
                }
            }
            .disabled(model.userInputDisabled)
            .listStyle(GroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(model.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    init(_ model: Model) {
        self.model = model
    }
}

private extension BiometricUnlockPreferencesView {
    
    struct Header: View {
        
        let biometryType: BiometryType
        
        var body: some View {
            HStack {
                Spacer()
                
                Image.faceID
                    .frame(width: 60, height: 60)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    .foregroundColor(.secondaryLabel)
                
                Spacer()
            }
        }
        
    }
    
    struct ErrorMessage: View {
        
        let status: BiometricUnlockPreferencesStatus
        let biometryType: BiometryType
        
        var body: some View {
            HStack {
                Spacer()
                
                switch status {
                case .none, .loading:
                    EmptyView()
                case .biometricActivationFailed:
                    switch biometryType {
                    case .touchID:
                        Text(LocalizedString.touchIDActivationFailed)
                    case .faceID:
                        Text(LocalizedString.faceIDActivationFailed)
                    }
                case .invalidPassword:
                    Text(LocalizedString.invalidPassword)
                }
                
                Spacer()
            }
            .padding(.all, 10)
        }
        
    }
    
}

private extension BiometricUnlockPreferencesModelRepresentable {
    
    var userInputDisabled: Bool { status == .loading }
    
    var navigationTitle: String {
        switch self.biometryType {
        case .touchID:
            return LocalizedString.touchID
        case .faceID:
            return LocalizedString.faceID
        }
    }
    
    var enterMasterPasswordDescription: String {
        switch self.biometryType {
        case .touchID:
            return LocalizedString.enableTouchIDUnlockDescription
        case .faceID:
            return LocalizedString.enableFaceIDUnlockDescription
        }
    }
    
}
#endif
