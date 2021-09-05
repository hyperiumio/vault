import SwiftUI

struct PasswordGeneratorView: View {
    
    @ObservedObject private var state: PasswordGeneratorState
    private let onPassword: (String) -> Void
     
    init(state: PasswordGeneratorState, onPassword: @escaping (String) -> Void) {
        self.state = state
        self.onPassword = onPassword
    }
    
    var length: Binding<Double> {
        Binding {
            Double(state.length)
        } set: { length in
            let length = Int(length)
            guard length != state.length else {
                return
            }
            state.length = length
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(state.password)
                .font(.body.monospaced())
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Group {
                HStack() {
                    #warning("workaround")
                    Text("")
                        .monospacedDigit()
                    
                    Slider(value: length, in: 16...64, step: 1)
                }
                
                Toggle(.numbers, isOn: $state.digitsEnabled)
                
                Toggle(.symbols, isOn: $state.symbolsEnabled)
            }
            .toggleStyle(.switch)
            .foregroundStyle(.secondary)
            .tint(.accentColor)
        }
        .onChange(of: state.password, perform: onPassword)
        .task {
            state.generatePassword()
        }
    }
    
}

#if DEBUG
struct PasswordGeneratorViewPreview: PreviewProvider {
    
    static let state = PasswordGeneratorState(service: .stub)
    
    static var previews: some View {
        PasswordGeneratorView(state: state) { password in
            print(password)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        PasswordGeneratorView(state: state) { password in
            print(password)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
