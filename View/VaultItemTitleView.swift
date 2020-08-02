import SwiftUI

struct VaultItemTitleView: View {
    
    let secureItemType: SecureItemType
    let title: String
    
    var body: some View {
        HStack(spacing: 0) {
            Image(secureItemType)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(Color(secureItemType))
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                
                Text(secureItemType.title)
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
            }
        }
        .padding(.vertical)
    }
    
}

#if DEBUG
struct VaultItemTitleViewProvider: PreviewProvider {
    
    static var previews: some View {
        VaultItemTitleView(secureItemType: .note, title: "Google")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
