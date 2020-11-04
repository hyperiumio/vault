import Localization
import SwiftUI

#if os(iOS)
struct CustomView: View {
    
    private let item: CustomItem
    
    init(_ item: CustomItem) {
        self.item = item
    }
    
    var body: some View {
        if item.description?.isEmpty == false || item.value?.isEmpty == false {
            SecureItemTextField(item.description ?? "", text: item.value ?? "")
        }
    }
    
}
#endif

#if os(iOS) && DEBUG
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
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
