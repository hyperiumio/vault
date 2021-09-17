#if os(iOS)
import SwiftUI

public struct FileExporter: UIViewControllerRepresentable {
    
    private let urls: [URL]
    private let onCompletion: () -> Void
    @Environment(\.presentationMode) private var presentationMode
    
    public init(urls: [URL], onCompletion: @escaping () -> Void) {
        print(urls)
        self.urls = urls
        self.onCompletion = onCompletion
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(presentationMode: presentationMode, onCompletion: onCompletion)
    }
    
    public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forExporting: urls)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
}

public extension FileExporter {
    
    class Coordinator: NSObject {
        
        private let presentationMode: Binding<PresentationMode>
        private let onCompletion: () -> Void
        
        init(presentationMode: Binding<PresentationMode>, onCompletion: @escaping () -> Void) {
            self.presentationMode = presentationMode
            self.onCompletion = onCompletion
        }
        
    }
    
}

extension FileExporter.Coordinator: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        onCompletion()
        presentationMode.wrappedValue.dismiss()
    }
    
}
#endif
