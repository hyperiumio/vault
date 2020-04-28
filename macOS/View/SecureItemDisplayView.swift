import SwiftUI

struct SecureItemDisplayView: View {
    
    let model: SecureItemDisplayModel
    
    var body: some View {
        switch model {
        case .login(let model):
            return LoginDisplayView(model: model).eraseToAnyView()
        case .password(let model):
            return PasswordDisplayView(model: model).eraseToAnyView()
        case .file(let model):
            return FileDisplayView(model: model).eraseToAnyView()
        case .note(let model):
            return NoteDisplayView(model: model).eraseToAnyView()
        }
    }
    
}

