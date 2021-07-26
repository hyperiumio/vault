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
        .buttonStyle(.message(""))
    }
    
}

#if DEBUG
struct CustomFieldPreview: PreviewProvider {
    
    static let item = CustomItem(description: "foo", value: "bar")
    
    static var previews: some View {
        List {
            CustomField(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            CustomField(item)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
