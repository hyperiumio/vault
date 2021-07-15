import SwiftUI

struct AppCommands: Commands {
    
    var body: some Commands {
        SidebarCommands()
        
        CommandGroup(before: .appTermination) {
            Button(.lockVault) {

            }
        }
    }
    
}
