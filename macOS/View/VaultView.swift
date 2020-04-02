import SwiftUI

struct VaultView: View {
    
    @ObservedObject var model: VaultModel
    
    var body: some View {
        return Text("VaultView")
            .frame(minWidth: 500, minHeight: 500)
    }
    
}
