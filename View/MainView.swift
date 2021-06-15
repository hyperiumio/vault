import SwiftUI

struct MainView<Model>: View where Model: MainModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        switch model.state {
        case .locked(let model):
            LockedView(model)
        case .unlocked(let model):
            UnlockedView(model)
        }
    }
    
}

#if DEBUG
struct MainViewPreview: PreviewProvider {
    
    static var model: MainModelStub = {
        let lockedModel = MainModelStub.LockedModel()
        let state = MainModelStub.State.locked(model: lockedModel)
        return MainModelStub(state: state)
    }()
    
    static var previews: some View {
        MainView(model)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
