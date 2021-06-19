import Format
import SwiftUI

struct BankCardInputField<BankCardInputState>: View where BankCardInputState: BankCardStateRepresentable {
    
    @ObservedObject private var state: BankCardInputState
    
    init(_ state: BankCardInputState) {
        self.state = state
    }
    
    var body: some View {
        Field(.name) {
            TextField(.accountHolder, text: $state.name)
                .keyboardType(.namePhonePad)
                .textContentType(.name)
        }
        
        Field(.number) {
            TextField(.number, value: $state.number, format: .creditCardNumber)
                .font(.body.monospaced())
                .keyboardType(.numberPad)
                .textContentType(.creditCardNumber)
        }
        
        Field(.expirationDate) {
            HStack {
                DatePicker(.expirationDate, selection: $state.expirationDate, displayedComponents: .date)
                    .labelsHidden()
                    #if os(macOS)
                    .datePickerStyle(.field)
                    #endif
                
                Spacer()
            }
        }
        
        Field(.pin) {
            SecureField(.pin, text: $state.pin, prompt: nil)
        }
    }
    
}

#if DEBUG
struct BankCardInputFieldPreview: PreviewProvider {
    
    static let state = BankCardStateStub()
    
    static var previews: some View {
        List {
            BankCardInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
