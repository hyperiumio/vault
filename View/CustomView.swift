import SwiftUI

struct CustomView: View {
    
    private let description: LocalizedStringKey
    private let value: String
    
    init(description: String?, value: String?) {
        self.description = LocalizedStringKey(description ?? "")
        self.value = value ?? ""
    }
    
    var body: some View {
        ItemTextField(description, text: value)
    }
    
}

#if DEBUG
struct CustomViewPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            CustomView(description: "foo", value: "bar")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
