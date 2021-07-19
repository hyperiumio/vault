import Model
import Pasteboard
import SwiftUI

struct CustomField: View {
    
    private let item: CustomItem
    
    init(_ item: CustomItem) {
        self.item = item
    }
    
    var body: some View {
        Button {
            Pasteboard.general.string = item.value
        } label: {
            Field(item.description ?? "") {
                Text(item.value ?? "")
            }
        }
        .buttonStyle(.message(.copied))
    }
    
}
