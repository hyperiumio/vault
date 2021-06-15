import SwiftUI

struct AppCommands<Model>: Commands where Model: AppModelRepresentable {
    
    @ObservedObject var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some Commands {
        SidebarCommands()
        
        CommandGroup(before: .appTermination) {
            Button(.lockVault) {
                guard case .main(let model) = model.state else { return }
                
           //     model.lock()
            }
        }
    }
    
    
}
