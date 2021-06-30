import Crypto
import SwiftUI
#warning("todo")
struct PasswordGeneratorView: View {
    
    private let passwordGenerator: (String?) -> Void
    
    @State private var length = 32 as Double
    @State private var digitsEnabled = true
    @State private var symbolsEnabled = true
    @State private var password = ""
     
    init(passwordGenerator: @escaping (String?) -> Void) {
        self.passwordGenerator = passwordGenerator
    }
    
    var body: some View {
        VStack {
            Text(password)
                .font(.body.monospaced())
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            HStack() {
                Text(.localizedCharacters(Int(length)))
                    .monospacedDigit()
                
                Slider(value: $length, in: 16...64, step: 1)
            }
            
            Toggle(.numbers, isOn: $digitsEnabled)
            
            Toggle(.symbols, isOn: $symbolsEnabled)
        }
        .toggleStyle(.switch)
        .foregroundStyle(.secondary)
        .task(id: length) {
            do {
                password = try await Password(length: Int(length), uppercase: true, lowercase: true, digit: digitsEnabled, symbol: symbolsEnabled)
            } catch {
                
            }
        }
        .task(id: digitsEnabled) {
            do {
                password = try await Password(length: Int(length), uppercase: true, lowercase: true, digit: digitsEnabled, symbol: symbolsEnabled)
            } catch {
                
            }
        }
        .task(id: symbolsEnabled) {
            do {
                password = try await Password(length: Int(length), uppercase: true, lowercase: true, digit: digitsEnabled, symbol: symbolsEnabled)
            } catch {
                
            }
        }
        .onChange(of: password, perform: passwordGenerator)
    }
    
}
