import Combine
import SwiftUI
import UniformTypeIdentifiers

struct FilePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    let picked: (Output?) -> Void
    
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
        
        private let picked: (Output?) -> Void
        private let operationQueue = DispatchQueue(label: "FilePickerCoordinatorOperationQueue")
        private var didPickSubscription: AnyCancellable?
        
        init(presentationMode: Binding<PresentationMode>, picked: @escaping (Output?) -> Void) {
            self.picked = { output in
                picked(output)
                presentationMode.wrappedValue.dismiss()
            }
        }

    }
    
}

extension FilePicker.Coordinator: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
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
        .sink { output in
            self.picked(output)
        }
    }
    
}
