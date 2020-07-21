import Localization
import SwiftUI

struct LoginEditView: View {
    
    @ObservedObject var model: LoginEditModel
    
    var body: some View {
        VStack {
            TextField(LocalizedString.user, text: $model.user)
            SecureField(LocalizedString.password, text: $model.password)
        }
    }
    
}
