import SwiftUI

struct ItemButton<Content>: View where Content: View {
    
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
            withAnimation(.buttonFadeInOut) {
                isMessageShow = true
            }
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { timer in
                withAnimation(.buttonFadeInOut) {
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
                    Text(.copied)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
        }
        .listRowInsets(EdgeInsets())
    }
    
}

private extension Animation {
    
    static var buttonFadeInOut: Self { Animation.easeIn(duration: 0.2) }
    
}

#if DEBUG
struct ItemButtonPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            List {
                ItemButton {} content: {
                    Text("foo")
                }
            }
            .preferredColorScheme(.light)
            
            List {
                ItemButton {} content: {
                    Text("foo")
                }
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
