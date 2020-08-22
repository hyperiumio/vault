import SwiftUI

struct VaultItemInfoView: View {
    
    let info: VaultItemInfo
    
    var body: some View {
        Label {
            VStack(alignment: .leading) {
                Text(info.name)
                
                if !info.description.isEmpty {
                    Text(info.description)
                        .font(.footnote)
                        .foregroundColor(.secondaryLabel)
                }
            }
        } icon: {
            Image(info.primaryTypeIdentifier)
                .imageScale(.large)
                .foregroundColor(Color(info.primaryTypeIdentifier))
        }
        .padding(.vertical, 2)
    }
    
    init(_ info: VaultItemInfo) {
        self.info = info
    }
    
}
