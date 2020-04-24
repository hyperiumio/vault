import SwiftUI

struct PasswordDisplayView: View {
    
    @ObservedObject var model: PasswordDisplayModel
    
    var body: some View {
        return VStack {
            Text(model.password)
        }
    }
    
}
