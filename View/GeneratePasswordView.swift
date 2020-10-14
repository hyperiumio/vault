import Localization
import SwiftUI

struct GeneratePasswordView: View {
    
    @State private var showControls = false
    @State private var configuration = Configuration()
    private let action: Action
    
    var length: Int {
        Int(configuration.length)
    }
    
    init(action: @escaping Action) {
        self.action = action
    }
    
    var body: some View {
        VStack {
            Group {
                if showControls {
                    HStack() {
                        Text(LocalizedString.characters(length))
                        
                        Slider(value: $configuration.length, in: 8 ... 32, step: 1)
                    }
                    
                    Toggle(LocalizedString.numbers, isOn: $configuration.digitsEnabled)
                    
                    Toggle(LocalizedString.symbols, isOn: $configuration.symbolsEnabled)
                } else {
                    Button(LocalizedString.generatePassword) {
                        showControls = true
                    }
                    .buttonStyle(ColoredButtonStyle(.accentColor, size: .small))
                }
                
            }
            .font(Font.body.monospacedDigit())
            .foregroundColor(.secondaryLabel)
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
        }
        
        .onChange(of: configuration) { configuration in
            action(length, configuration.digitsEnabled, configuration.symbolsEnabled)
        }
        .onChange(of: showControls) { showControls in
            guard showControls else { return }
            
            action(length, configuration.digitsEnabled, configuration.symbolsEnabled)
        }

    }
    
}

extension GeneratePasswordView {
    
    typealias Action = (_ length: Int, _ digitsEnabled: Bool, _ symbolsEnabled: Bool) -> Void
    
    private struct Configuration: Equatable {
        
        var length = 16 as Double
        var digitsEnabled = true
        var symbolsEnabled = true
        
    }
    
}
