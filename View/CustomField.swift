import Pasteboard
import SwiftUI

struct CustomField: View {
    
    private let description: String
    private let value: String
    
    init(description: String?, value: String?) {
        self.description = description ?? ""
        self.value = value ?? ""
    }
    
    var body: some View {
        Button {
            Pasteboard.general.string = value
        } label: {
            Field(description) {
                Text(value)
            }
        }
        .buttonStyle(.message(.copied))
    }
    
}

#if DEBUG
struct CustomFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            CustomField(description: "foo", value: "bar")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
