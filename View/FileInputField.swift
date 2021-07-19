import PDFKit
import SwiftUI
import UniformTypeIdentifiers

struct FileInputField: View {
    
    @ObservedObject private var state: FileItemState
    
    init(_ state: FileItemState) {
        self.state = state
    }
    
    var body: some View {
        Text("missing")
    }
    
}
