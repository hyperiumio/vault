import Localization
import SwiftUI

struct SecureItemButton<Content>: View where Content: View {
    
    private let action: () -> Void
    private let content: Content
    @State private var isMessageShow = false
    @State private var timer: Timer?
    
    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button {
            withAnimation(Animation.easeInOut(duration: 0.1)) {
                isMessageShow = true
            }
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                withAnimation(Animation.easeInOut(duration: 0.2)) {
                    isMessageShow = false
                }
            }
            
            action()
        } label: {
            ZStack {
                content
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .opacity(isMessageShow ? 0 : 1)
                
                if isMessageShow {
                    Text(LocalizedString.copied)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.accentColor)
                }
            }
        }
        .buttonStyle(BareButtonStyle())
        .listRowInsets(EdgeInsets())
    }
    
}
