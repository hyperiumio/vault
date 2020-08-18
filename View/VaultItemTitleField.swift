import Localization
import SwiftUI

struct VaultItemTitleField: View {
    
    let text: Binding<String>
    
    @Binding var isEditable: Bool
    
    var body: some View {
        TextField(LocalizedString.title, text: text)
            .font(.title3)
            .padding(.vertical)
            .disabled(!isEditable)
            
    }
    
}
