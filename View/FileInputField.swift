import PDFKit
import SwiftUI
import UniformTypeIdentifiers

struct FileInputField: View {
    
    @ObservedObject private var state: FileItemState
    
    init(_ state: FileItemState) {
        self.state = state
    }
    
    var body: some View {
        if let value = state.value {
            FileField(data: value.data, type: value.type)
        } else {
            Text("missing")
        }
    }
    
}
