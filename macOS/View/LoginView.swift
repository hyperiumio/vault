import SwiftUI

struct LoginView: View {
    
    @ObservedObject var model: LoginModel
    
    var body: some View {
        return VStack {
            TextField(.user, text: $model.user)
            SecureField(.password, text: $model.password)
        }
    }
    
}
