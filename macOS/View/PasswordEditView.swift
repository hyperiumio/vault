import SwiftUI

struct PasswordEditView: View {
    
    @ObservedObject var model: PasswordEditModel
    
    var body: some View {
        return VStack {
            SecureField(.password, text: $model.password)
        }
    }
    
}
