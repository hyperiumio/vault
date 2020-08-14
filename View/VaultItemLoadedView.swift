import SwiftUI

struct VaultItemLoadedView: View {
    
    @ObservedObject var model: VaultItemLoadedModel
    
    var body: some View {
        switch model.state {
        case .display(let model):
            VaultItemDisplayView(model: model)
        case .edit(let model, _):
            VaultItemEditView(model: model)
        }
    }
}
