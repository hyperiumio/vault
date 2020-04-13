import SwiftUI

struct FileStateLoadedView: View {
    
    @ObservedObject var model: FileStateLoadedModel
    
    var body: some View {
        return Text("Loaded")
            .onDrag(model.itemProvider)
    }
    
}
