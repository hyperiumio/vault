import Pasteboard
import SwiftUI

struct BankCardField: View {
    
    private let name: String?
    private let vendor: Vendor?
    private let number: String?
    private let expirationDate: Date?
    private let pin: String?
    @State private var pinIsVisisble = false
    
    init(name: String?, vendor: Vendor?, number: String?, expirationDate: Date?, pin: String?) {
        self.name = name
        self.vendor = vendor
        self.number = number
        self.expirationDate = expirationDate
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
                    Pasteboard.general.string = Date.FormatStyle(date: .complete).format(expirationDate)
                } label: {
                    Field(.expirationDate) {
                        Text(expirationDate, format: Date.FormatStyle(date: .abbreviated))
                    }
                }
            }
            
            if let pin = pin {
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
