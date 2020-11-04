#if os(iOS)
import Combine
import PDFKit
import SwiftUI
import UniformTypeIdentifiers
import VisionKit

struct DocumentPicker: UIViewControllerRepresentable {
    
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

extension DocumentPicker {
    
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

extension DocumentPicker.Coordinator: VNDocumentCameraViewControllerDelegate {
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        picked(nil)
        presentationMode.wrappedValue.dismiss()
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        picked(nil)
        presentationMode.wrappedValue.dismiss()
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        presentationMode.wrappedValue.dismiss()
        
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
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: picked)

    }
    
}
#endif

#if os(iOS) && DEBUG
struct DocumentPickerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            DocumentPicker { _ in }
                .preferredColorScheme(.light)
            
            DocumentPicker { _ in }
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
