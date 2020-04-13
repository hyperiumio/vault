import SwiftUI

struct MenuItem: View {
    
    let titleKey: LocalizedStringKey
    let action: () -> Void
    
    var body: some View {
        return Button(action: action) {
            Text(titleKey)
        }
    }
    
}
