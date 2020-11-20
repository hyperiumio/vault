import SwiftUI

struct MainView<Model>: View where Model: MainModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            switch model.state {
            case .locked(let model, let useBiometricUnlock):
                LockedView(model, useBiometricsOnAppear: useBiometricUnlock)
                    .transition(.unlock)
                    .zIndex(1)
            case .unlocked(let model):
                UnlockedView(model)
                    .zIndex(0)
            }
        }
    }
    
}

private extension AnyTransition {
    
    static var unlock: Self {
        AnyTransition.scale(scale: 2).combined(with: .opacity).animation(.easeInOut)
    }
    
}

#if DEBUG
struct MainViewPreview: PreviewProvider {
    
    static var model: MainModelStub {
        let lockedModel = LockedModelStub()
        let state = MainModelStub.State.locked(model: lockedModel, userBiometricUnlock: false)
        return MainModelStub(state: state)
    }
    
    static var previews: some View {
        Group {
            MainView(model)
                .preferredColorScheme(.light)
            
            MainView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
