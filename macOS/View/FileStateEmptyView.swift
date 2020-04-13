import SwiftUI

struct FileStateEmptyView: View {
    
    @ObservedObject var model: FileStateEmptyModel
    @State var isTargeted = false
    
    var body: some View {
        return Text("Drop file")
            .onDrop(of: model.supportedTypes, delegate: self)
    }
    
}

extension FileStateEmptyView: DropDelegate {
    
    func validateDrop(info: DropInfo) -> Bool {
        let itemProviders = info.itemProviders(for: model.supportedTypes)
        return model.validateDrop(for: itemProviders)
    }

    func performDrop(info: DropInfo) -> Bool {
        let itemProviders = info.itemProviders(for: model.supportedTypes)
        return model.receiveDrop(with: itemProviders)
    }

    func dropEntered(info: DropInfo) {
        isTargeted = true
    }

    func dropExited(info: DropInfo) {
        isTargeted = false
    }
    
}
