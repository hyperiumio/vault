import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    let picked: (Output?) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(presentationMode: presentationMode, picked: picked)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let configuration = PHPickerConfiguration()
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
}

extension ImagePicker {
    
    typealias Output = (data: Data, type: UTType)
    
    class Coordinator: NSObject {
        
        private let picked: (Output?) -> Void
        private let operationQueue = DispatchQueue(label: "ImagePickerCoordinatorOperationQueue")
        
        init(presentationMode: Binding<PresentationMode>, picked: @escaping (Output?) -> Void) {
            self.picked = { output in
                picked(output)
                presentationMode.wrappedValue.dismiss()
            }
        }

    }
    
}

extension ImagePicker.Coordinator: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let itemProvider = results.first?.itemProvider else {
            picked(nil)
            return
        }
        
        itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { [picked] url, error  in
            guard let url = url, let data = try? Data(contentsOf: url) else {
                DispatchQueue.main.async {
                    picked(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                let output = (data: data, type: UTType.image)
                picked(output)
            }
        }
    }
    
}
