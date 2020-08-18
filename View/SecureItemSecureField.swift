import SwiftUI

struct SecureItemSecureField: View {
    
    let title: String
    let text: Binding<String>
    
    @State private var secureDisplay = true
    @Binding var isEditable: Bool
    
    var body: some View {
        HStack {
            SecureItemField(title) {
                if secureDisplay || isEditable {
                    SecureField(title, text: text)
                        .disabled(!isEditable)
                } else {
                    TextField(title, text: text)
                        .disabled(!isEditable)
                }
            }
            
            if !isEditable {
                Spacer()
                
                Button {
                    secureDisplay.toggle()
                } label: {
                    if secureDisplay {
                        Image.hideSecret
                    } else {
                        Image.showSecret
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .transition(.jumpInFadeOut)
            }
        }
        
    }
    
}

private extension AnyTransition {
    
    static var jumpInFadeOut: AnyTransition {
        let insertionAnimation = Animation.interpolatingSpring(stiffness: 1000, damping: 30)
        let insertionTransition = AnyTransition.scale.animation(insertionAnimation).combined(with: .opacity)
        let removalAnimation = Animation.easeIn(duration: 0.1)
        let removaltransition = AnyTransition.opacity.animation(removalAnimation)
        return AnyTransition.asymmetric(insertion: insertionTransition, removal: removaltransition)
    }
    
}
