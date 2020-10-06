import SwiftUI

struct HeaderLabelStyle: LabelStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.icon
            
            configuration.title
        }
        .textCase(.none)
        .font(.footnote)
    }
    
}
