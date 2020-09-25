import Localization
import SwiftUI

struct FileView<Model>: View where Model: FileModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemContainer {
            SecureItemDisplayField(LocalizedString.filename) {
                switch (model.data, model.format) {
                case (nil, _):
                    Text("Select File")
                case (let data?, .pdf):
                    FilePDFView(data: data)
                case (let data?, .image):
                    FileImageView(data: data)
                case (.some, .unrepresentable):
                    FileGenericView()
                }
            }
        }
    }
    
}
