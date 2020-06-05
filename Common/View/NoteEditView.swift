import SwiftUI

struct NoteEditView: View {
    
    @ObservedObject var model: NoteEditModel
    
    var body: some View {
        return VStack {
            TextField(.notePlaceholder, text: $model.text)
        }
    }
    
}
