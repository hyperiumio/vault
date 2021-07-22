import Resource
import Format
import SwiftUI

struct BankCardInputField: View {
    
    @ObservedObject private var state: BankCardItemState
    
    init(_ state: BankCardItemState) {
        self.state = state
    }
    
    var body: some View {
        Field(Localized.name) {
            TextField(Localized.accountHolder, text: $state.name)
                #if os(iOS)
                .keyboardType(.namePhonePad)
                .textContentType(.name)
                #endif
        }
        
        Field(Localized.number) {
            TextField(Localized.number, value: $state.number, format: .creditCardNumber)
                .font(.body.monospaced())
                #if os(iOS)
                .keyboardType(.numberPad)
                .textContentType(.creditCardNumber)
                #endif
        }
        
        Field(Localized.expirationDate) {
            HStack {
                DatePicker(Localized.expirationDate, selection: $state.expirationDate, displayedComponents: .date)
                    .labelsHidden()
                    #if os(macOS)
                    .datePickerStyle(.field)
                    #endif
                
                Spacer()
            }
        }
        
        Field(Localized.pin) {
            SecureField(Localized.pin, text: $state.pin, prompt: nil)
        }
    }
    
}
