import SwiftUI

struct PasswordGeneratorView: View {
    
    @StateObject private var state = PasswordGeneratorState()
    private let onPassword: (String) -> Void
     
    init(onPassword: @escaping (String) -> Void) {
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
                    Text(.localizedCharacters(state.length))
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
            await state.generatePassword()
        }
    }
    
}