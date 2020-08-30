import SwiftUI

struct VaultItemInfoView: View {
    
    let name: String
    let description: String
    let itemType: SecureItemTypeIdentifier
    
    var body: some View {
        Label {
            VStack(alignment: .leading) {
                Text(name)
                
                if !description.isEmpty {
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.secondaryLabel)
                }
            }
        } icon: {
            Image(itemType)
                .imageScale(.large)
                .foregroundColor(Color(itemType))
        }
        .padding(.vertical, 2)
    }
    
    init(_ name: String, description: String, itemType: SecureItemTypeIdentifier) {
        self.name = name
        self.description = description
        self.itemType = itemType
    }
    
}
