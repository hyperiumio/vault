import Localization
import SwiftUI

struct SelectCategoryView: View {
    
    private let action: (SecureItemType) -> Void
    @Environment(\.presentationMode) private var presentationMode
    
    init(action: @escaping (SecureItemType) -> Void) {
        self.action = action
    }
    
    var body: some View {
        NavigationView {
            List(Self.types) { type in
                Button {
                    action(type)
                } label: {
                    Label {
                        Text(type.name)
                    } icon: {
                        type.image
                            .foregroundColor(type.color)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle(LocalizedString.selectCategory, displayMode: .inline)
        }
    }
    
}

extension SelectCategoryView {
    
    private static let types = [
        .login,
        .password,
        .wifi,
        .note,
        .file,
        .bankCard,
        .bankAccount,
        .custom
    ] as [SecureItemType]
    
}
