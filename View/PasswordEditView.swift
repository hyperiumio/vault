import Localization
import SwiftUI

struct PasswordEditView: View {
    
    @ObservedObject var model: PasswordEditModel
    
    var body: some View {
        VStack {
            SecureField(LocalizedString.password, text: $model.password)
        }
    }
    
}
