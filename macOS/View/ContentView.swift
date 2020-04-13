import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model: ContentModel
    
    var body: some View {
        switch model.state {
        case .setup(let model):
            return SetupView(model: model).eraseToAnyView()
        case .locked(let model):
            return LockedView(model: model).eraseToAnyView()
        case .unlocked(let model):
            return UnlockedView(model: model).eraseToAnyView()
        }
    }
    
}
