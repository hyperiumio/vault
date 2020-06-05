import SwiftUI

struct FileDisplayView: View {
    
    @ObservedObject var model: FileDisplayModel
    
    var body: some View {
        return VStack {
            Text(model.filename)
            
            FileContentView(fileData: model.fileData, fileFormat: model.fileFormat)
        }
    }
    
}
