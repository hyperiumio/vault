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
                withAnimation(Animation.easeInOut(duration: 0.1)) {
                    isMessageShow = false
                }
            }
            
            action()
        } label: {
            ZStack {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding()
                    .contentShape(Rectangle())
                    .opacity(isMessageShow ? 0 : 1)
                
                if isMessageShow {
                    Text(LocalizedString.copied)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.appTeal)
                }
            }
        }
        .listRowInsets(.zero)
        .buttonStyle(BareButtonStyle())
    }
    
}

struct SecureItemView<Content>: View where Content: View {
    
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .listRowInsets(.zero)
            .padding()
    }
    
}
