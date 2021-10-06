import SwiftUI

struct UnlockSetupView: View {
    
    @ObservedObject private var state: UnlockSetupState
    
    init(_ state: UnlockSetupState) {
        self.state = state
    }
    
    var body: some View {
        SetupContentView(buttonEnabled: state.status == .input) {
            state.confirm()
        } image: {
            Image(state.unlockMethod.image)
        } title: {
            Text(state.unlockMethod.title)
        } description: {
            Text(state.unlockMethod.description)
        } input: {
            Toggle(state.unlockMethod.title, isOn: $state.isEnabled)
                .toggleStyle(.switch)
                .labelsHidden()
                .tint(.accentColor)
                .disabled(state.status == .setupComplete)
        } button: {
            Text(.continue)
        }
    }
    
}

private extension UnlockSetupState.UnlockMethod {
    
    var image: String {
        switch self {
        case .touchID:
            return ImageAsset.unlockSetupTouchID.name
        case .faceID:
            return ImageAsset.unlockSetupFaceID.name
        case .watch:
            return ImageAsset.unlockSetupWatch.name
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .touchID:
            return .enableTouchIDUnlock
        case .faceID:
            return .enableFaceIDUnlock
        case .watch:
            return .enabledWatchUnlock
        }
    }
    
    var description: LocalizedStringKey {
        switch self {
        case .touchID:
            return .enableFaceIDUnlockDescription
        case .faceID:
            return .enableTouchIDUnlockDescription
        case .watch:
            return .enabledWatchUnlockDescription
        }
    }
    
}

#if DEBUG
struct UnlockSetupViewPreview: PreviewProvider {
    
    static let state = UnlockSetupState(unlockMethod: .touchID, isEnabled: false)
    
    static var previews: some View {
        UnlockSetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        UnlockSetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
