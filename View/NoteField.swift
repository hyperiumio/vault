import Pasteboard
import SwiftUI

struct NoteField: View {
    
    private let text: String?
    
    init(text: String?) {
        self.text = text
    }
    
    var body: some View {
        if let text = text {
            Button {
                Pasteboard.general.string = text
            } label: {
                Field(.note) {
                    Text(text)
                }
            }
            .buttonStyle(.message(.copied))
        }
        
    }
    
}
