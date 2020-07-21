import SwiftUI

struct VaultItemLoadedView: View {
    
    @ObservedObject var model: VaultItemLoadedModel
    
    @ViewBuilder var body: some View {
        switch model.state {
        case .display(let model):
            VaultItemDisplayView(model: model)
        case .edit(let model):
            VaultItemEditView(model: model)
        }
    }
}
