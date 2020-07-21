import Localization
import SwiftUI

struct NoteEditView: View {
    
    @ObservedObject var model: NoteEditModel
    
    var body: some View {
        VStack {
            TextField(LocalizedString.notePlaceholder, text: $model.text)
        }
    }
    
}
