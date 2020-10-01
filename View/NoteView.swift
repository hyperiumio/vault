import Localization
import SwiftUI

struct NoteDisplayView<Model>: View where Model: NoteModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextDisplayField(LocalizedString.note, text: model.text)
    }
    
}


struct NoteEditView<Model>: View where Model: NoteModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemDisplayField(LocalizedString.note) {
            TextEditor(text: $model.text)
                .frame(minHeight: 40)
        }
    }
    
}
