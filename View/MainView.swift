import SwiftUI

struct MainView<Model>: View where Model: MainModelRepresentable {
    
    @ObservedObject private var model: Model
    
    var body: some View {
        Group {
            switch model.state {
            case .locked(let model, let useBiometricUnlock):
                LockedView(model, useBiometricsOnAppear: useBiometricUnlock)
                    .transition(AnyTransition.scale(scale: 2).combined(with: .opacity).animation(.easeInOut))
                    .zIndex(1)
            case .unlocked(let model):
                UnlockedView(model)
                    .zIndex(0)
            }
        }
    }
    
    init(_ model: Model) {
        self.model = model
    }
    
}
