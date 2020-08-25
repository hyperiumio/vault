import SwiftUI

struct SecureItemSecureField: View {
    
    let title: String
    let text: Binding<String>
    let isEditable: Binding<Bool>
    
    @State private var secureDisplay = true
    
    var body: some View {
        HStack {
            SecureItemField(title) {
                if secureDisplay || isEditable.wrappedValue {
                    SecureField(title, text: text)
                } else {
                    TextField(title, text: text)
                }
            }
            .disabled(!isEditable.wrappedValue)
            
            if !isEditable.wrappedValue {
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
    
    init(_ title: String, text: Binding<String>, isEditable: Binding<Bool>) {
        self.title = title
        self.text = text
        self.isEditable = isEditable
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

#if DEBUG
struct SecureItemSecureFieldPreviews: PreviewProvider {
    
    @State static var text = ""
    @State static var isEditable = false
    
    static var previews: some View {
        SecureItemSecureField("Title", text: $text, isEditable: $isEditable)
    }
    
}
#endif
