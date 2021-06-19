import Pasteboard
import SwiftUI

struct BankCardField: View {
    
    private let name: String?
    private let vendor: Vendor?
    private let number: String?
    private let expirationDate: String?
    private let pin: String?
    @State private var pinIsVisisble = false
    
    init(name: String?, vendor: Vendor?, number: String?, expirationDate: Date?, pin: String?) {
        self.name = name
        self.vendor = vendor
        self.number = number
        self.expirationDate = expirationDate.map { expirationDate in
            Date.FormatStyle(date: .abbreviated).format(expirationDate)
        }
        self.pin = pin
    }
    
    var body: some View {
        Group {
            if let name = name {
                Button {
                    Pasteboard.general.string = name
                } label: {
                    Field(.name) {
                        Text(name)
                    }
                }
            }
            
            if let vendor = vendor {
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
            
            if let number = number {
                Button {
                    Pasteboard.general.string = number
                } label: {
                    Field(.number) {
                        Text(number)
                            .font(.body.monospaced())
                    }
                }
            }
            
            if let expirationDate = expirationDate {
                Button {
                    Pasteboard.general.string = expirationDate
                } label: {
                    Field(.expirationDate) {
                        Text(expirationDate)
                    }
                }
            }
            
            if let pin = pin {
                Toggle(isOn: $pinIsVisisble) {
                    Button {
                        Pasteboard.general.string = pin
                    } label: {
                        Field(.pin) {
                            Text(pinIsVisisble ? pin : "••••••••")
                                .font(.body.monospaced())
                        }
                    }
                }
            }
        }
        .buttonStyle(.message(.copied))
        .toggleStyle(.secure)
    }
    
}

extension BankCardField {
    
    enum Vendor {
        
        case masterCard
        case visa
        case americanExpress
        
    }
    
}

#if DEBUG
struct BankCardFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            BankCardField(name: "foo", vendor: .masterCard, number: "1234567", expirationDate: Date(), pin: "paz")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
