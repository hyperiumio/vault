#if os(iOS)
import Combine
import PDFKit
import SwiftUI
import UniformTypeIdentifiers
import VisionKit

struct DocumentPickerShim: UIViewControllerRepresentable {
    
    private let picked: (Output?) -> Void
    @Environment(\.presentationMode) private var presentationMode
    
    init(picked: @escaping (Output?) -> Void) {
        self.picked = picked
    }
    
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

extension DocumentPickerShim {
    
    typealias Output = (data: Data, type: UTType)
    
    class Coordinator: NSObject {
        
        private let presentationMode: Binding<PresentationMode>
        private let picked: (Output?) -> Void
        private let operationQueue = DispatchQueue(label: "DocumentPickerCoordinatorOperationQueue")
        private var didPickSubscription: AnyCancellable?
        
        init(presentationMode: Binding<PresentationMode>, picked: @escaping (Output?) -> Void) {
            self.presentationMode = presentationMode
            self.picked = picked
        }

    }
    
}

extension DocumentPickerShim.Coordinator: VNDocumentCameraViewControllerDelegate {
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        picked(nil)
        presentationMode.wrappedValue.dismiss()
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        picked(nil)
        presentationMode.wrappedValue.dismiss()
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        didPickSubscription = operationQueue.future { () -> DocumentPickerShim.Output? in
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
        .receive(on: DispatchQueue.main)
        .sink { [picked, presentationMode] output in
            picked(output)
            presentationMode.wrappedValue.dismiss()
        }

    }
    
}

private extension DispatchQueue {
    
    func future<Success>(catching body: @escaping () -> Success) -> Future<Success, Never> {
        Future { promise in
            self.async {
                let success = body()
                let result = Result<Success, Never>.success(success)
                promise(result)
            }
        }
    }
    
}
#endif
