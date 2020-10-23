import Localization
import SwiftUI

struct FileItemEditView<Model>: View where Model: FileModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var isShowingPhotoPicker = false
    @State private var isShowingDocumentPicker = false
    @State private var isShowingDocumentScanner = false
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        switch model.status {
        case .empty, .loading:
            ProgressView()
        case let .loaded(data, type):
            FileView(data, type: type)
                .listRowInsets(.zero)
        }
    }
    
}

extension FileItemEditView {
    
    struct ImportButton: View {
        
        private let text: String
        private let image: Image
        private let action: () -> Void
        
        init(_ text: String, image: Image, action: @escaping () -> Void) {
            self.text = text
            self.image = image
            self.action = action
        }
        
        var body: some View {
            Button(action: action) {
                Label {
                    Text(text)
                } icon: {
                    image
                }
            }
        }
        
    }
    
}
