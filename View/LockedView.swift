import SwiftUI

struct LockedView: View {
    
    @ObservedObject private var state: LockedState
    @FocusState private var isMasterPasswordFieldFocused: Bool
    private let presentsUnlockFailure: Binding<Bool>
    
    init(_ state: LockedState) {
        self.state = state
        
        self.presentsUnlockFailure = Binding {
            state.unlockDidFail
        } set: { presentsUnlockFailure in
            if presentsUnlockFailure {
                state.presentUnlockFailed()
            } else {
                state.dismissUnlockFailed()
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                SecureField(.masterPassword, text: $state.password, prompt: nil)
                    .font(.title2)
                    .textFieldStyle(.plain)
                    .padding(.horizontal)
                    .padding()
                    .submitLabel(.continue)
                    .layoutPriority(1)
                    .focused($isMasterPasswordFieldFocused)
                
                Button {
                    isMasterPasswordFieldFocused = false
                    state.unlock(with: .password)
                } label: {
                    Image(systemName: SFSymbol.lock.systemName)
                        .imageScale(.large)
                        .foregroundColor(.white)
                        .frame(maxHeight: .infinity)
                        .padding(.horizontal)
                        .background(Color.accentColor)
                }
                .buttonStyle(.plain)
            }
            .background(.quaternary)
            .fixedSize(horizontal: false, vertical: true)
            .clipShape(.buttonShape)
            .frame(maxWidth: 400)
            
            Spacer()
                .frame(height: 40)
            
            if let biometryType = state.biometry {
                Button {
                    state.unlock(with: .biometry)
                } label: {
                    Image(systemName: biometryType.symbolName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                        .frame(width: 40, height: 40)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
        .disabled(state.isUnlocking)
        .alert(.unlockFailed, isPresented: presentsUnlockFailure) {
            Button(.cancel, role: .cancel) {
                state.dismissUnlockFailed()
            }
        }
    }
    
}

extension LockedView {
    
    enum Field {
        
        case masterPassword
        
    }
    
}

private extension LockedState {
    
    var isUnlocking: Bool {
        switch status {
        case .unlocking:
            return true
        case .locked, .unlocked, .unlockFailed:
            return false
        }
    }
    
    var unlockDidFail: Bool {
        switch status {
        case .unlockFailed:
            return true
        case .locked, .unlocked, .unlocking:
            return false
        }
    }
    
}

private extension AppServiceBiometry {
    
    var symbolName: String {
        switch self {
        case .touchID:
            return SFSymbol.touchid.systemName
        case .faceID:
            return SFSymbol.faceid.systemName
        }
    }
    
}

private extension Shape where Self == RoundedRectangle {
    
    static var buttonShape: Self {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
    }
    
}

#if DEBUG
struct LockedViewPreview: PreviewProvider {
    
    static let state = LockedState(service: .stub)
    
    static var previews: some View {
        LockedView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        LockedView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
