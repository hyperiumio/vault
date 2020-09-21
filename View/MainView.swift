import SwiftUI

struct MainView<Model>: View where Model: MainModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        Group {
            switch model.state {
            case .locked(let model, let useBiometricUnlock):
                LockedView(model, useBiometricsOnAppear: useBiometricUnlock)
            case .unlocked(let model):
                UnlockedView(model)
            }
        }
    }
    
    init(_ model: Model) {
        self.model = model
    }
    
}
