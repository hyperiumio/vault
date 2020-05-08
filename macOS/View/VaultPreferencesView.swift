import SwiftUI

struct VaultPreferencesView: View {
    
    @ObservedObject var model: VaultPreferencesModel
    
    var body: some View {
        return VStack {
            Button(.changeMasterPassword, action: model.changeMasterPassword)
        }
    }
    
}
