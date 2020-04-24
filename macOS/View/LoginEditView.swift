import SwiftUI

struct LoginEditView: View {
    
    @ObservedObject var model: LoginEditModel
    
    var body: some View {
        return VStack {
            TextField(.user, text: $model.user)
            SecureField(.password, text: $model.password)
        }
    }
    
}
