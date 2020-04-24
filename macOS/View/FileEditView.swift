import SwiftUI

struct FileEditView: View {
    
    @ObservedObject var model: FileEditModel
    @State var isTargeted = false
    
    var body: some View {
        return VStack {
            TextField(.fileName, text: $model.fileName)
            
            FileStateView(fileState: model.fileState)
        }
    }
    
}
