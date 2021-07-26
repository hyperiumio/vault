import Resource
import Model
import Pasteboard
import SwiftUI

struct BankCardField: View {
    
    private let item: BankCardItem
    @State private var pinIsVisisble = false
    
    init(_ item: BankCardItem) {
        self.item = item
    }
    
    var body: some View {
        Group {
            if let name = item.name {
                Button {
                    Pasteboard.general.string = name
                } label: {
                    Field(Localized.name) {
                        Text(name)
                    }
                }
            }
            
            if let vendor = item.vendor {
                Field(Localized.vendor) {
                    switch vendor {
                    case .masterCard:
                        Text(Localized.mastercard)
                    case .visa:
                        Text(Localized.visa)
                    case .americanExpress:
                        Text(Localized.americanExpress)
                    }
                }
            }
            
            if let number = item.number {
                Button {
                    Pasteboard.general.string = number
                } label: {
                    Field(Localized.number) {
                        Text(number)
                            .font(.body.monospaced())
                    }
                }
            }
            
            if let expirationDate = item.expirationDate {
                Button {
                    Pasteboard.general.string = Date.FormatStyle(date: .complete).format(expirationDate)
                } label: {
                    Field(Localized.expirationDate) {
                        Text(expirationDate, format: Date.FormatStyle(date: .abbreviated))
                    }
                }
            }
            
            if let pin = item.pin {
                Toggle(isOn: $pinIsVisisble) {
                    Button {
                        Pasteboard.general.string = pin
                    } label: {
                        Field(Localized.pin) {
                            ConfidentialText(pin, isVisible: pinIsVisisble)
                        }
                    }
                }
            }
        }
        .buttonStyle(.message(Localized.copied))
        .toggleStyle(.secure)
    }
    
}

#if DEBUG
struct BankCardFieldPreview: PreviewProvider {
    
    static let item = BankCardItem(name: "foo", number: "bar", expirationDate: .now, pin: "baz")
    
    static var previews: some View {
        List {
            BankCardField(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            BankCardField(item)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
