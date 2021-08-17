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
                    Field(.name) {
                        Text(name)
                    }
                }
            }
            
            if let vendor = item.vendor {
                Field(.vendor) {
                    switch vendor {
                    case .masterCard:
                        Text(.mastercard)
                    case .visa:
                        Text(.visa)
                    case .americanExpress:
                        Text(.americanExpress)
                    }
                }
            }
            
            if let number = item.number {
                Button {
                    Pasteboard.general.string = number
                } label: {
                    Field(.number) {
                        Text(number)
                            .font(.body.monospaced())
                    }
                }
            }
            
            if let expirationDate = item.expirationDate {
                Button {
                    Pasteboard.general.string = Date.FormatStyle(date: .complete).format(expirationDate)
                } label: {
                    Field(.expirationDate) {
                        Text(expirationDate, format: Date.FormatStyle(date: .abbreviated))
                    }
                }
            }
            
            if let pin = item.pin {
                Toggle(isOn: $pinIsVisisble) {
                    Button {
                        Pasteboard.general.string = pin
                    } label: {
                        Field(.pin) {
                            ConfidentialText(pin, isVisible: pinIsVisisble)
                        }
                    }
                }
            }
        }
        .buttonStyle(.message(.copied))
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
