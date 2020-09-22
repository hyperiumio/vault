import Localization
import SwiftUI

struct NoteView<Model>: View where Model: NoteModelRepresentable {
    
    @ObservedObject private var model: Model
    
    private let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemTextEditorField(LocalizedString.note, text: $model.text, isEditable: isEditable)
        }
    }
    
    init(_ model: Model, isEditable: Binding<Bool>) {
        self.model = model
        self.isEditable = isEditable
    }
    
}
