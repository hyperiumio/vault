import Localization
import SwiftUI

struct CustomView: View {
    
    private let item: CustomItem
    
    init(_ item: CustomItem) {
        self.item = item
    }
    
    var body: some View {
        SecureItemTextDisplayField(item.name ?? "", text: item.value ?? "")
    }
    
}
