import SwiftUI

struct FileView: View {
    
    @ObservedObject var model: FileModel
    @State var isTargeted = false
    
    var body: some View {
        return VStack {
            TextField(.fileName, text: $model.fileName)
            
            FileStateView(fileState: model.fileState)
        }
    }
    
}
