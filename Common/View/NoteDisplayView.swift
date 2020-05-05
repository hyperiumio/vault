import SwiftUI

struct NoteDisplayView: View {
    
    @ObservedObject var model: NoteDisplayModel
    
    var body: some View {
        return VStack {
            Text(model.note)
        }
    }
    
}
