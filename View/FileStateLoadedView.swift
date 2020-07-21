import SwiftUI

struct FileStateLoadedView: View {
    
    @ObservedObject var model: FileLoadedModel
    
    var body: some View {
        Text(model.filename)
            .onDrag(model.itemProvider)
    }
    
}
