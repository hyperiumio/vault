import Combine
import SwiftUI
import UniformTypeIdentifiers

#if os(iOS)
struct FilePicker: UIViewControllerRepresentable {
    
    private let picked: (Output?) -> Void
    @Environment(\.presentationMode) private var presentationMode
    
    init(picked: @escaping (Output?) -> Void) {
        self.picked = picked
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(presentationMode: presentationMode, picked: picked)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
}

extension FilePicker {
    
    typealias Output = (data: Data, type: UTType)
    
    class Coordinator: NSObject {
        
        private let presentationMode: Binding<PresentationMode>
        private let picked: (Output?) -> Void
        private let operationQueue = DispatchQueue(label: "FilePickerCoordinatorOperationQueue")
        private var didPickSubscription: AnyCancellable?
        
        init(presentationMode: Binding<PresentationMode>, picked: @escaping (Output?) -> Void) {
            self.presentationMode = presentationMode
            self.picked = picked
        }
        
    }
    
}

extension FilePicker.Coordinator: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        presentationMode.wrappedValue.dismiss()
        
        didPickSubscription = operationQueue.future {
            let resourceKeys = [URLResourceKey.contentTypeKey] as Set
            guard let fileURL = urls.first else {
                return nil
            }
            guard let type = try? fileURL.resourceValues(forKeys: resourceKeys).contentType else {
                return nil
            }
            
            let data = try Data(contentsOf: fileURL)
            return (data: data, type: type)
        }
        .replaceError(with: nil)
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: picked)
    }
    
}
#endif

#if os(iOS) && DEBUG
struct FilePickerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            FilePicker { _ in }
                .preferredColorScheme(.light)
            
            FilePicker { _ in }
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
