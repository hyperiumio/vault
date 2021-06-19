import SwiftUI

#warning("TODO")
struct GeneratePasswordView: View {
    
    let passworGenerator: (String?) -> Void
    
    @StateObject private var state = GeneratePasswordState()
    
    private var length: Binding<Double> {
        Binding<Double> {
            Double(state.length)
        } set: { length in
            let length = Int(length)
            guard state.length != length else { return }
            
            state.length = length
        }
    }
    
    init(passworGenerator: @escaping (String?) -> Void) {
        self.passworGenerator = passworGenerator
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(state.password ?? "")
                .font(.body.monospaced())
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            HStack() {
                Text(.localizedCharacters(state.length))
                
                Slider(value: length, in: 16 ... 64)
            }
            
            Toggle(.numbers, isOn: $state.digitsEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            
            Toggle(.symbols, isOn: $state.symbolsEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        }
        .monospacedDigit()
        .foregroundStyle(.secondary)
        .onChange(of: state.password, perform: passworGenerator)
        .onAppear {
            async {
                await state.createPassword()
            }
        }
    }
    
}

private extension HorizontalAlignment {
    
    struct CustomAlignment: AlignmentID {
        
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
        
    }

    static let custom = HorizontalAlignment(CustomAlignment.self)
}

#if DEBUG
struct GeneratePasswordViewPreview: PreviewProvider {
    
    static var previews: some View {
        GeneratePasswordView { _ in }
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
