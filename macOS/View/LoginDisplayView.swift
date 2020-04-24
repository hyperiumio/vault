import SwiftUI

struct LoginDisplayView: View {
    
    @ObservedObject var model: LoginDisplayModel
    
    var body: some View {
        return VStack {
            Text(model.username)
            Text(model.password)
        }
    }
    
}
