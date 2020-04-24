import SwiftUI

struct PasswordDisplayView: View {
    
    @ObservedObject var model: PasswordDisplayModel
    
    var body: some View {
        return VStack {
            SecureText(content: model.password, secureDisplay: $model.secureDisplay)
                .onTapGesture(perform: model.copyPasswordToPasteboard)
        }
    }
    
}
