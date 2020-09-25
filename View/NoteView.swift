import Localization
import SwiftUI

struct NoteDisplayView<Model>: View where Model: NoteModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemContainer {
            SecureItemTextField(LocalizedString.note, text: model.text)
        }
    }
    
}
