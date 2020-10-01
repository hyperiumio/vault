import Localization
import SwiftUI

struct PasswordGeneratorView: View {
    
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
            Toggle("Generate password", isOn: $showControls)
            
            if showControls {
                HStack {
                    Text("Length")
                    
                    Slider(value: $configuration.length, in: 8 ... 32, step: 1)
                    
                    Text(String(length))
                }
                
                Toggle("Digits", isOn: $configuration.digitsEnabled)
                
                Toggle("Symbols", isOn: $configuration.symbolsEnabled)
                
                Button {
                    action(length, configuration.digitsEnabled, configuration.symbolsEnabled)
                } label: {
                    HStack {
                        Text("Shuffle")
                        
                        Spacer()
                        
                        Image.random
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.accentColor)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .font(.subheadline)
        .foregroundColor(.secondaryLabel)
        .onChange(of: configuration) { configuration in
            action(length, configuration.digitsEnabled, configuration.symbolsEnabled)
        }
        .onChange(of: showControls) { showControls in
            guard showControls else { return }
            action(length, configuration.digitsEnabled, configuration.symbolsEnabled)
        }
    }
    
}

extension PasswordGeneratorView {
    
    typealias Action = (_ length: Int, _ digitsEnabled: Bool, _ symbolsEnabled: Bool) -> Void
    
    private struct Configuration: Equatable {
        
        var length = 16 as Double
        var digitsEnabled = true
        var symbolsEnabled = false
        
    }
    
}
