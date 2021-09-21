#if os(iOS)
import SwiftUI

public struct FileExporter: UIViewControllerRepresentable {
    
    private let urls: [URL]
    @Environment(\.presentationMode) private var presentationMode
    
    public init(urls: [URL]) {
        self.urls = urls
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(presentationMode: presentationMode)
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
        
        init(presentationMode: Binding<PresentationMode>) {
            self.presentationMode = presentationMode
        }
        
    }
    
}

extension FileExporter.Coordinator: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        presentationMode.wrappedValue.dismiss()
    }
    
}
#endif
