#if os(iOS)
import SwiftUI
import UniformTypeIdentifiers

public struct FileExporter: UIViewControllerRepresentable {
    
    private let allowedContentTypes: [UTType]
    private let onCompletion: (URL) -> Void
    @Environment(\.presentationMode) private var presentationMode
    
    public init(allowedContentTypes: [UTType], onCompletion: @escaping (URL) -> Void) {
        self.allowedContentTypes = allowedContentTypes
        self.onCompletion = onCompletion
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(presentationMode: presentationMode, onCompletion: onCompletion)
    }
    
    public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forExporting: [])
        controller.delegate = context.coordinator
        
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
}

public extension FileExporter {
    
    class Coordinator: NSObject {
        
        private let presentationMode: Binding<PresentationMode>
        private let onCompletion: (URL) -> Void
        
        init(presentationMode: Binding<PresentationMode>, onCompletion: @escaping (URL) -> Void) {
            self.presentationMode = presentationMode
            self.onCompletion = onCompletion
        }
        
    }
    
}

extension FileExporter.Coordinator: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }
        onCompletion(url)
        presentationMode.wrappedValue.dismiss()
    }
    
}
#endif
