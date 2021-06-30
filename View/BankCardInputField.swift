import Format
import SwiftUI

struct BankCardInputField: View {
    
    @ObservedObject private var state: BankCardState
    
    init(_ state: BankCardState) {
        self.state = state
    }
    
    var body: some View {
        Field(.name) {
            TextField(.accountHolder, text: $state.name)
                #if os(iOS)
                .keyboardType(.namePhonePad)
                .textContentType(.name)
                #endif
        }
        
        Field(.number) {
            TextField(.number, value: $state.number, format: .creditCardNumber)
                .font(.body.monospaced())
                #if os(iOS)
                .keyboardType(.numberPad)
                .textContentType(.creditCardNumber)
                #endif
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
