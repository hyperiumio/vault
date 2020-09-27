import Localization
import SwiftUI

struct VaultItemElementDisplayView<Model>: View where Model: VaultItemModelRepresentable {
    
    private let element: Model.Element
    
    init(_ element: Model.Element) {
        self.element = element
    }
    
    var body: some View {
        switch element {
        case .login(let model):
            LoginView(model)
        case .password(let model):
            PasswordView(model)
        case .file(let model):
            FileView(model)
        case .note(let model):
            NoteView(model)
        case .bankCard(let model):
            BankCardView(model)
        case .wifi(let model):
            WifiView(model)
        case .bankAccount(let model):
            BankAccountView(model)
        case .custom(let model):
            CustomItemView(model)
        }
    }
    
}

private extension VaultItemElementDisplayView {
    
    struct Container<Content>: View where Content: View {
        
        private let content: Content
        
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                content
            }
            .padding(.vertical)
        }
        
    }

    struct Field<Content>: View where Content: View {
        
        private let title: String
        private let content: Content
        
        init(_ title: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
                
                content
            }
        }
        
    }

    struct TextField: View {
        
        private let title: String
        private let text: String
        
        init(_ title: String, text: String) {
            self.title = title
            self.text = text
        }
        
        var body: some View {
            Field(title) {
                Text(text)
            }
        }
        
    }

    struct SecureTextField: View {
        
        private let title: String
        private let text: String
        @State private var secureDisplay = true
        
        init(_ title: String, text: String) {
            self.title = title
            self.text = text
        }
        
        var body: some View {
            HStack {
                Field(title) {
                    Text(secureDisplay ? "••••••••" : text)
                }
                
                Spacer()
                
                Button {
                    secureDisplay.toggle()
                } label: {
                    if secureDisplay {
                        Image.hideSecret
                    } else {
                        Image.showSecret
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            
        }
        
    }

    struct DateField: View {
        
        private let title: String
        private let date: Date
        
        init(_ title: String, date: Date) {
            self.title = title
            self.date = date
        }
        
        var body: some View {
            Field(title) {
                Text(date, style: .date)
            }
        }
        
    }

    struct BankCardVendorField: View {
        
        private let vendor: BankCardItemVendor
        
        init(_ vendor: BankCardItemVendor) {
            self.vendor = vendor
        }
        
        var body: some View {
            Field(LocalizedString.bankCardVendor) {
                switch vendor {
                case .masterCard:
                    Text(LocalizedString.mastercard)
                case .visa:
                    Text(LocalizedString.visa)
                case .americanExpress:
                    Text(LocalizedString.americanExpress)
                case .other:
                    Text(LocalizedString.other)
                }
            }
        }
        
    }

    struct LoginView<Model>: View where Model: LoginModelRepresentable {
        
        @ObservedObject private var model: Model
        
        init(_ model: Model) {
            self.model = model
        }
        
        var body: some View {
            Container {
                TextField(LocalizedString.user, text: model.username)
                
                SecureTextField(LocalizedString.password, text: model.password)
                
                TextField(LocalizedString.url, text: model.url)
            }
        }
        
    }

    struct PasswordView<Model>: View where Model: PasswordModelRepresentable {
        
        @ObservedObject private var model: Model
        
        init(_ model: Model) {
            self.model = model
        }
        
        var body: some View {
            Container {
                SecureTextField(LocalizedString.password, text: model.password)
            }
        }

    }

    struct FileView<Model>: View where Model: FileModelRepresentable {
        
        @ObservedObject private var model: Model
        
        init(_ model: Model) {
            self.model = model
        }
        
        var body: some View {
            Container {
                Field(LocalizedString.filename) {
                    switch (model.data, model.format) {
                    case (nil, _):
                        Text("Select File")
                    case (let data?, .pdf):
                        FilePDFView(data: data)
                    case (let data?, .image):
                        FileImageView(data: data)
                    case (.some, .unrepresentable):
                        FileGenericView()
                    }
                }
            }
        }
        
    }

    struct NoteView<Model>: View where Model: NoteModelRepresentable {
        
        @ObservedObject private var model: Model
        
        init(_ model: Model) {
            self.model = model
        }
        
        var body: some View {
            Container {
                TextField(LocalizedString.note, text: model.text)
            }
        }
        
    }

    struct BankCardView<Model>: View where Model: BankCardModelRepresentable {
        
        @ObservedObject private var model: Model
        
        init(_ model: Model) {
            self.model = model
        }
        
        var body: some View {
            Container {
                TextField(LocalizedString.bankCardName, text: model.name)
                
                if let vendor = model.vendor {
                    BankCardVendorField(vendor)
                }
                
                TextField(LocalizedString.bankCardNumber, text: model.number)
                
                DateField(LocalizedString.bankCardExpirationDate, date: model.expirationDate)
                
                SecureTextField(LocalizedString.bankCardPin, text: model.pin)
            }
        }
    }

    struct WifiView<Model>: View where Model: WifiModelRepresentable {
        
        @ObservedObject private var model: Model
        
        init(_ model: Model) {
            self.model = model
        }
        
        var body: some View {
            Container {
                TextField(LocalizedString.wifiNetworkName, text: model.networkName)
                
                SecureTextField(LocalizedString.wifiNetworkPassword, text: model.networkPassword)
            }
        }
        
    }

    struct BankAccountView<Model>: View where Model: BankAccountModelRepresentable {
        
        @ObservedObject private var model: Model
        
        init(_ model: Model) {
            self.model = model
        }
        
        var body: some View {
            Container {
                SecureTextField(LocalizedString.bankAccountHolder, text: model.accountHolder)
                
                SecureTextField(LocalizedString.bankAccountIban, text: model.iban)
                
                SecureTextField(LocalizedString.bankAccountBic, text: model.bic)
            }
        }
        
    }

    struct CustomItemView<Model>: View where Model: CustomItemModelRepresentable {
        
        @ObservedObject private var model: Model
        
        init(_ model: Model) {
            self.model = model
        }
        
        var body: some View {
            Container {
                TextField(model.name, text: model.value)
            }
        }
        
    }
}
