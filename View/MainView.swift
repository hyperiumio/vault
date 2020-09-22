import SwiftUI

struct MainView<Model>: View where Model: MainModelRepresentable {
    
    @ObservedObject private var model: Model
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        Group {
            switch model.state {
            case .locked(let model, let useBiometricUnlock):
                LockedView(model, useBiometricsOnAppear: useBiometricUnlock)
            case .unlocked(let model):
                UnlockedView(model)
            }
        }
        .onChange(of: scenePhase) { scenePhase in
            if scenePhase == .background {
                model.lock()
            }
        }
    }
    
    init(_ model: Model) {
        self.model = model
    }
    
}
