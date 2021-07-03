import SwiftUI
#warning("todo")
struct SettingsView: View {
    
    @ObservedObject private var state: SettingsState
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                switch state.keychainAvailability {
                case .notAvailable, .notEnrolled:
                    EmptyView()
                case .enrolled(.touchID):
                    Section {
                        Toggle(.useTouchID, isOn: $state.isBiometricUnlockEnabled)
                    } footer: {
                        Text(.touchIDDescription)
                    }
                case .enrolled(.faceID):
                    Section {
                        Toggle(.useFaceID, isOn: $state.isBiometricUnlockEnabled)
                    } footer: {
                        Text(.faceIDDescription)
                    }
                }
                
                Section {
                    NavigationLink(.changeMasterPassword, destination: MasterPasswordSettingsView())
                } footer: {
                    Text(.changeMasterPasswordDescription)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            #if os(iOS)
            .listStyle(GroupedListStyle())
            #endif
            .navigationTitle(.settings)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    init(_ state: SettingsState) {
        self.state = state
    }
    
}

/*
struct ChoosePasswordView<ChoosePasswordState>: View where ChoosePasswordState: ChoosePasswordStateRepresentable {
    
    @ObservedObject private var state: ChoosePasswordState
    
    init(_ state: ChoosePasswordState) {
        self.state = state
    }
    
    var body: some View {
        PageNavigationView(.continue, isEnabled: !state.password.isEmpty) {
            async {
                await state.choosePassword()
            }
        } content: {
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    Text(.chooseMasterPassword)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text(.chooseMasterPasswordDescription)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                SecureField(.enterMasterPassword, text: $state.password, prompt: nil)
                    .textContentType(.oneTimeCode)
                    .font(.title2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
        }
    }
    
}
 */

/*
struct EnableBiometricUnlockView<EnableBiometricUnlockState>: View where EnableBiometricUnlockState: EnableBiometricUnlockStateRepresentable {
    
    @ObservedObject private var state: EnableBiometricUnlockState
    @State private var error: EnableBiometricUnlockError?
    
    init(_ state: EnableBiometricUnlockState) {
        self.state = state
    }
    
    var body: some View {
        PageNavigationView(.continue, enabledIntensions: [.backward, .forward]) { intension in
            switch intension {
            case .forward:
                async {
                    await state.done()
                }
            case .backward:
                async {
                    await state.dismiss()
                }
            }
        } content: {
            VStack {
                Spacer()
                
                VStack {
                    switch state.biometryType {
                    case .touchID:
                        Content(imageName: .touchid, title: .enableTouchIDUnlock, description: .unlockWithTouchIDDescription, isEnabled: $state.isEnabled)
                    case .faceID:
                        Content(imageName: .faceid, title: .enableFaceIDUnlock, description: .unlockWithFaceIDDescription, isEnabled: $state.isEnabled)
                    }
                }
                
                Spacer()
            }
        }
    }
    
}

private struct Content: View {
    
    private let imageName: String
    private let title: LocalizedStringKey
    private let description: LocalizedStringKey
    private let isEnabled: Binding<Bool>
    
    init(imageName: String, title: LocalizedStringKey, description: LocalizedStringKey, isEnabled: Binding<Bool>) {
        self.imageName = imageName
        self.title = title
        self.description = description
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .frame(width: 100, height: 100, alignment: .center)
            
            Spacer().frame(height: 40)
            
            HStack {
                Text(.enableTouchIDUnlock)
                    .font(.title)
                
                Toggle(.enableTouchIDUnlock, isOn:isEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .labelsHidden()
            }
            
            Spacer().frame(height: 10)
            
            Text(description)
                .font(.body)
    //            .foregroundColor(.secondaryLabel)
                .multilineTextAlignment(.center)
        }
    }
    
}

private extension EnableBiometricUnlockView {
    
    static func title(for error: EnableBiometricUnlockError, biometryType: Keychain.BiometryType) -> Text {
        switch (error, biometryType) {
        case (.didFailEnabling, .touchID):
            return Text(.touchIDActivationFailed)
        case (.didFailEnabling, .faceID):
            return Text(.faceIDActivationFailed)
        case (.didFailDisabling, .touchID):
            return Text(.touchIDDeactivationFailed)
        case (.didFailDisabling, .faceID):
            return Text(.faceIDDeactivationFailed)
        }
    }
    
}
 */
