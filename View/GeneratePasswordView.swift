import SwiftUI

struct GeneratePasswordView: View {
    
    let passworGenerator: (String?) -> Void
    
    @StateObject private var model = GeneratePasswordModel()
    
    private var length: Binding<Double> {
        Binding<Double> {
            Double(model.length)
        } set: { length in
            let length = Int(length)
            guard model.length != length else { return }
            
            model.length = length
        }
    }
    
    init(passworGenerator: @escaping (String?) -> Void) {
        self.passworGenerator = passworGenerator
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.password ?? "")
                .font(.body.monospaced())
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            HStack() {
                Text(.localizedCharacters(model.length))
                
                Slider(value: length, in: 16 ... 64)
            }
            
            Toggle(.numbers, isOn: $model.digitsEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            
            Toggle(.symbols, isOn: $model.symbolsEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        }
        .monospacedDigit()
        .foregroundStyle(.secondary)
        .onChange(of: model.password, perform: passworGenerator)
        .onAppear {
            async {
                await model.createPassword()
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
