import Combine
import PDFKit
import SwiftUI
import VisionKit
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    let picked: (Output?) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(presentationMode: presentationMode, picked: picked)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
}

extension DocumentPicker {
    
    typealias Output = (data: Data, type: UTType)
    
    class Coordinator: NSObject {
        
        private let picked: (Output?) -> Void
        private let operationQueue = DispatchQueue(label: "DocumentPickerCoordinatorOperationQueue")
        private var didPickSubscription: AnyCancellable?
        
        init(presentationMode: Binding<PresentationMode>, picked: @escaping (Output?) -> Void) {
            self.picked = { output in
                picked(output)
                presentationMode.wrappedValue.dismiss()
            }
        }

    }
    
}

extension DocumentPicker.Coordinator: VNDocumentCameraViewControllerDelegate {
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        picked(nil)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        picked(nil)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        didPickSubscription = operationQueue.future {
            let document = PDFDocument()
            for index in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: index)
                guard let page = PDFPage(image: image) else { continue }
                document.insert(page, at: index)
            }
            guard let data = document.dataRepresentation() else {
                return nil
            }
            
            return (data: data, type: UTType.pdf)
        }
        .replaceError(with: nil)
        .receive(on: DispatchQueue.main)
        .sink { output in
            self.picked(output)
        }

    }
    
}
