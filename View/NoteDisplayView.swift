import SwiftUI

struct NoteDisplayView: View {
    
    @ObservedObject var model: NoteDisplayModel
    
    var body: some View {
        VStack {
            Text(model.text)
        }
    }
    
}
