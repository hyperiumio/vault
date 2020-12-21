import SwiftUI
import UniformTypeIdentifiers

#if os(iOS)
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
    
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    ItemButton(.login, imageName: SFSymbolName.personFill) {
                        action(.login)
                    }
                    
                    ItemButton(.password, imageName: SFSymbolName.keyFill) {
                        action(.password)
                    }
                    
                    ItemButton(.wifi, imageName: SFSymbolName.wifi) {
                        action(.wifi)
                    }
                    
                    ItemButton(.note, imageName: SFSymbolName.noteText) {
                        action(.note)
                    }
                    
                    ItemButton(.bankCard, imageName: SFSymbolName.creditcard) {
                        action(.bankCard)
                    }
                    
                    ItemButton(.bankAccount, imageName: SFSymbolName.dollarsignCircle) {
                        action(.bankAccount)
                    }
                    
                    ItemButton(.custom, imageName: SFSymbolName.scribbleVariable) {
                        action(.custom)
                    }
                }
                
                Group {
                    ItemButton(.photo, imageName: SFSymbolName.camera) {
                        isShowingCameraView = true
                    }
                    .fullScreenCover(isPresented: $isShowingCameraView) {
                        PhotoPickerShim { output in
                            guard let output = output else { return }
                            
                            let selection = Selection.file(data: output.data, type: output.type)
                            action(selection)
                        }
                    }
                    
                    ItemButton(.document, imageName: SFSymbolName.docTextViewfinder) {
                        isShowingScannerView = true
                    }
                    .fullScreenCover(isPresented: $isShowingScannerView) {
                        DocumentPickerShim { output in
                            guard let output = output else { return }
                            
                            let selection = Selection.file(data: output.data, type: output.type)
                            action(selection)
                        }
                    }
                    
                    ItemButton(.image, imageName: SFSymbolName.photoOnRectangle) {
                        isShowingImagePicker = true
                    }
                    .sheet(isPresented: $isShowingImagePicker) {
                        ImagePickerShim { output in
                            guard let output = output else { return }
                            
                            let selection = Selection.file(data: output.data, type: output.type)
                            action(selection)
                        }
                    }
                    
                    ItemButton(.file, imageName: SFSymbolName.paperclip) {
                        isShowingFilePicker = true
                        
                    }
                    .sheet(isPresented: $isShowingFilePicker) {
                        FilePickerShim { output in
                            guard let output = output else { return }
                            
                            let selection = Selection.file(data: output.data, type: output.type)
                            action(selection)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle(.selectCategory, displayMode: .inline)
        }
    }
    
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
        
        private let text: LocalizedStringKey
        private let imageName: String
        private let action: () -> Void
        
        init(_ text: LocalizedStringKey, imageName: String, action: @escaping () -> Void) {
            self.text = text
            self.imageName = imageName
            self.action = action
        }
        
        var body: some View {
            Button(action: action) {
                Label {
                    Text(text)
                } icon: {
                    Image(systemName: imageName)
                        .foregroundColor(.accentColor)
                }
            }
        }
        
    }
    
}
#endif

#if os(iOS) && DEBUG
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
