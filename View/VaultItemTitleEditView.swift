import Localization
import SwiftUI

struct VaultItemTitleEditView: View {
    
    let secureItemType: SecureItemType
    let title: Binding<String>
    
    var body: some View {
        HStack(spacing: 0) {
            Image(secureItemType)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(Color(secureItemType))
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                TextField(LocalizedString.title, text: title)
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
struct VaultItemEditViewProvider: PreviewProvider {
    
    @State static var title = ""
    
    static var previews: some View {
        VaultItemTitleEditView(secureItemType: .note, title: $title)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
