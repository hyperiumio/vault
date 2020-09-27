import SwiftUI

struct VaultItemInfoView: View {
    
    private let name: String
    private let description: String
    private let typeIdentifier: SecureItemTypeIdentifier
    
    init(_ name: String, description: String, typeIdentifier: SecureItemTypeIdentifier) {
        self.name = name
        self.description = description
        self.typeIdentifier = typeIdentifier
    }
    
    var body: some View {
        HStack {
            typeIdentifier.image
                .imageScale(.large)
                .foregroundColor(typeIdentifier.color)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(name)
                
                if !description.isEmpty {
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.secondaryLabel)
                }
            }
        }
    }
    
}
