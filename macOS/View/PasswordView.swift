import SwiftUI

struct PasswordView: View {
    
    @ObservedObject var model: PasswordModel
    
    var body: some View {
        return VStack {
            SecureField(.password, text: $model.password)
        }
    }
    
}
