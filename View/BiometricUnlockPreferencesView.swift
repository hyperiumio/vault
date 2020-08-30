import Localization
import SwiftUI

struct BiometricUnlockPreferencesView<Model>: View where Model: BiometricUnlockPreferencesModelRepresentable {
    
    @ObservedObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    
    #if os(macOS)
    var body: some View {
        VStack {
            Header(biometricType: model.biometricType)
            
            SecureField(LocalizedString.masterPassword, text: $model.password)
                .frame(maxWidth: 300)
            
            Text(model.enterMasterPasswordDescription)
            
            HStack {
                Spacer()
                
                Button(LocalizedString.cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                Button(LocalizedString.enable, action: model.enabledBiometricUnlock)
            }
        }
        .disabled(model.userInputDisabled)
    }
    #endif
    
    #if os(iOS)
    var body: some View {
        NavigationView {
            List {
                Section(header: Header(biometricType: model.biometricType), footer: Text(model.enterMasterPasswordDescription)) {
                    SecureField(LocalizedString.masterPassword, text: $model.password)
                }
                
                Section(footer: ErrorMessage(status: model.status, biometricType: model.biometricType)) {
                    HStack {
                        Spacer()
                        
                        Button(LocalizedString.enable, action: model.enabledBiometricUnlock)
                        
                        Spacer()
                    }
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
    #endif
    
    init(_ model: Model) {
        self.model = model
    }
}

private extension BiometricUnlockPreferencesView {
    
    struct Header: View {
        
        let biometricType: BiometricType
        
        var body: some View {
            HStack {
                Spacer()
                
                BiometricIcon(biometricType)
                    .frame(width: 60, height: 60)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                
                Spacer()
            }
        }
        
    }
    
    struct ErrorMessage: View {
        
        let status: BiometricUnlockPreferencesStatus
        let biometricType: BiometricType
        
        var body: some View {
            HStack {
                Spacer()
                
                switch status {
                case .none, .loading:
                    EmptyView()
                case .biometricActivationFailed:
                    switch biometricType {
                    case .touchID:
                        ErrorBadge(LocalizedString.touchIDActivationFailed)
                    case .faceID:
                        ErrorBadge(LocalizedString.faceIDActivationFailed)
                    }
                case .invalidPassword:
                    ErrorBadge(LocalizedString.wrongPassword)
                }
                
                Spacer()
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
        
    }
    
}

private extension BiometricUnlockPreferencesModelRepresentable {
    
    var userInputDisabled: Bool { status == .loading }
    
    var navigationTitle: String {
        switch self.biometricType {
        case .touchID:
            return LocalizedString.touchID
        case .faceID:
            return LocalizedString.faceID
        }
    }
    
    var enterMasterPasswordDescription: String {
        switch self.biometricType {
        case .touchID:
            return LocalizedString.enableTouchIDUnlockDescription
        case .faceID:
            return LocalizedString.enableFaceIDUnlockDescription
        }
    }
    
}

#if DEBUG
struct BiometricUnlockPreferencesPreviews: PreviewProvider {
    
    static let model = BiometricUnlockPreferencesModelStub(password: "", status: .none, biometricType: .faceID)
    
    static var previews: some View {
        BiometricUnlockPreferencesView(model)
    }
    
}
#endif
