import Localization
import PDFKit
import SwiftUI

struct FileItemDisplayView<Model>: View where Model: FileModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        switch model.status {
        case .empty:
            Text("No file")
        case .loading:
            ProgressView()
        case let .loaded(data, type):
            FileView(data, type: type)
                .listRowInsets(.zero)
        }
    }
    
}
