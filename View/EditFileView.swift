import Localization
import PDFKit
import SwiftUI
import UniformTypeIdentifiers

struct EditFileView<Model>: View where Model: FileModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Text("foo")
    }
    
}
