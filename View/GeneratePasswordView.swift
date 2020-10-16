import Localization
import SwiftUI

struct GeneratePasswordView: View {
    
    let event: (String?) -> Void
    
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
    
    init(event: @escaping (String?) -> Void) {
        self.event = event
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.password ?? " ") // hack
                .font(Font.system(.body, design: .monospaced))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(minHeight: 22)
            
            HStack() {
                Text(LocalizedString.characters(model.length))
                
                Slider(value: length, in: 16 ... 64, step: 1)
            }
            
            Toggle(LocalizedString.numbers, isOn: $model.digitsEnabled)
            
            Toggle(LocalizedString.symbols, isOn: $model.symbolsEnabled)
        }
        .font(Font.body.monospacedDigit())
        .foregroundColor(.secondaryLabel)
        .onChange(of: model.password, perform: event)
        .onAppear(perform: model.createPassword)
    }
    
}
