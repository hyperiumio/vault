import PDFKit
import SwiftUI
import UniformTypeIdentifiers
#warning("Todo")
struct FileInputField: View {
    
    @ObservedObject private var state: FileState
    
    init(_ state: FileState) {
        self.state = state
    }
    
    var body: some View {
        fatalError()
        /*
        FileView(state.item)*/
    }
    
}
