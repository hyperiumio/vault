import SwiftUI

struct LoginDisplayView: View {
    
    @ObservedObject var model: LoginDisplayModel
    
    var body: some View {
        return VStack {
            Text(model.username)
            
            SecureText(content: model.password, secureDisplay: $model.secureDisplay)
                .onTapGesture(perform: model.copyPasswordToPasteboard)
        }
    }
    
}
