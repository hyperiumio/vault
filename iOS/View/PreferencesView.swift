import SwiftUI

struct PreferencesView: View {
    
    @ObservedObject var model: PreferencesModel
    
    var body: some View {
        return Form {
            Button(.changeMasterPassword, action: model.changeMasterPassword)
        }
    }
    
}
