import Storage
import SwiftUI

struct CustomView: View {
    
    private let item: CustomItem
    
    init(_ item: CustomItem) {
        self.item = item
    }
    
    var body: some View {
        if item.description?.isEmpty == false || item.value?.isEmpty == false {
            SecureItemTextField(LocalizedStringKey(item.description ?? ""), text: item.value ?? "")
        }
    }
    
}

#if DEBUG
struct CustomViewPreview: PreviewProvider {
    
    static let item = CustomItem(description: "foo", value: "bar")
    
    static var previews: some View {
        Group {
            List {
                CustomView(item)
            }
            .preferredColorScheme(.light)
            
            List {
                CustomView(item)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
