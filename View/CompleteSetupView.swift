import Haptic
import SwiftUI

struct CompleteSetupView: View {
    
    @ObservedObject private var state: CompleteSetupState
    
    init(_ state: CompleteSetupState) {
        self.state = state
    }
    
    var body: some View {
        VStack {
            Image("Placeholder")
            
            Text(.setupComplete)
                .font(.title)
            
            Text( .setupComplete)
                .font(.body)
                .foregroundStyle(.secondary)

            Spacer()
            
            Button {
                state.completeSetup()
            } label: {
                Text(.continue)
                    .frame(maxWidth: 400)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
        }
    }
    
}
