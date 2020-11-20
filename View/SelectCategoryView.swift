import Localization
import SwiftUI
import UniformTypeIdentifiers

struct SelectCategoryView: View {
    
    private let action: (Selection) -> Void
    @State private var isShowingCameraView = false
    @State private var isShowingImagePicker = false
    @State private var isShowingScannerView = false
    @State private var isShowingFilePicker = false
    @Environment(\.presentationMode) private var presentationMode
    
    init(action: @escaping (Selection) -> Void) {
        self.action = action
    }
    
    #if os(iOS)
    var body: some View {
        NavigationView {
            List {
                Group {
                    ItemButton(LocalizedString.login, image: .login) {
                        action(.login)
                    }
                    
                    ItemButton(LocalizedString.password, image: .password) {
                        action(.password)
                    }
                    
                    ItemButton(LocalizedString.wifi, image: .wifi) {
                        action(.wifi)
                    }
                    
                    ItemButton(LocalizedString.note, image: .note) {
                        action(.note)
                    }
                    
                    ItemButton(LocalizedString.bankCard, image: .bankCard) {
                        action(.bankCard)
                    }
                    
                    ItemButton(LocalizedString.bankAccount, image: .bankAccount) {
                        action(.bankAccount)
                    }
                    
                    ItemButton(LocalizedString.custom, image: .custom) {
                        action(.custom)
                    }
                }
                
                Group {
                    ItemButton(LocalizedString.photo, image: .photo) {
                        isShowingCameraView = true
                    }
                    .fullScreenCover(isPresented: $isShowingCameraView) {
                        PhotoPicker { output in
                            guard let output = output else { return }
                            
                            let selection = Selection.file(data: output.data, type: output.type)
                            action(selection)
                        }
                    }
                    
                    ItemButton(LocalizedString.document, image: .document) {
                        isShowingScannerView = true
                    }
                    .fullScreenCover(isPresented: $isShowingScannerView) {
                        DocumentPicker { output in
                            guard let output = output else { return }
                            
                            let selection = Selection.file(data: output.data, type: output.type)
                            action(selection)
                        }
                    }
                    
                    ItemButton(LocalizedString.image, image: .image) {
                        isShowingImagePicker = true
                    }
                    .sheet(isPresented: $isShowingImagePicker) {
                        ImagePicker { output in
                            guard let output = output else { return }
                            
                            let selection = Selection.file(data: output.data, type: output.type)
                            action(selection)
                        }
                    }
                    
                    ItemButton(LocalizedString.file, image: .file) {
                        isShowingFilePicker = true
                        
                    }
                    .sheet(isPresented: $isShowingFilePicker) {
                        FilePicker { output in
                            guard let output = output else { return }
                            
                            let selection = Selection.file(data: output.data, type: output.type)
                            action(selection)
                        }
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
    #endif
    
    #if os(macOS)
    var body: some View {
        List {
            ItemButton(LocalizedString.login, image: .login) {
                action(.login)
            }
            
            ItemButton(LocalizedString.password, image: .password) {
                action(.password)
            }
            
            ItemButton(LocalizedString.wifi, image: .wifi) {
                action(.wifi)
            }
            
            ItemButton(LocalizedString.note, image: .note) {
                action(.note)
            }
            
            ItemButton(LocalizedString.bankCard, image: .bankCard) {
                action(.bankCard)
            }
            
            ItemButton(LocalizedString.bankAccount, image: .bankAccount) {
                action(.bankAccount)
            }
            
            ItemButton(LocalizedString.custom, image: .custom) {
                action(.custom)
            }
        }
    }
    #endif
    
}

extension SelectCategoryView {
    
    enum Selection {
        
        case login
        case password
        case wifi
        case note
        case bankCard
        case bankAccount
        case custom
        case file(data: Data, type: UTType)
        
    }
    
    private struct ItemButton: View {
        
        private let text: String
        private let image: Image
        private let action: () -> Void
        
        init(_ text: String, image: Image, action: @escaping () -> Void) {
            self.text = text
            self.image = image
            self.action = action
        }
        
        var body: some View {
            Button(action: action) {
                Label {
                    Text(text)
                } icon: {
                    image
                        .foregroundColor(.accentColor)
                }
            }
        }
        
    }
    
}

#if DEBUG
struct SelectCategoryViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            SelectCategoryView { _ in }
                .preferredColorScheme(.light)
            
            SelectCategoryView { _ in }
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
