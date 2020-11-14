import Combine
import SwiftUI
import UniformTypeIdentifiers

#if os(iOS)
struct PhotoPicker: UIViewControllerRepresentable {
    
    private let picked: (Output?) -> Void
    @Environment(\.presentationMode) private var presentationMode
    
    init(picked: @escaping (Output?) -> Void) {
        self.picked = picked
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(presentationMode: presentationMode, picked: picked)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
}

extension PhotoPicker {
    
    typealias Output = (data: Data, type: UTType)
    
    class Coordinator: NSObject {
        
        private let presentationMode: Binding<PresentationMode>
        private let picked: (Output?) -> Void
        private let operationQueue = DispatchQueue(label: "PhotoPickerCoordinatorOperationQueue")
        private var didPickSubscription: AnyCancellable?
        
        init(presentationMode: Binding<PresentationMode>, picked: @escaping (Output?) -> Void) {
            self.presentationMode = presentationMode
            self.picked = picked
        }
        
    }
    
}

extension PhotoPicker.Coordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        didPickSubscription = operationQueue.future { () -> PhotoPicker.Output? in
            guard let identifier = info[.mediaType] as? String else {
                return nil
            }
            guard let type = UTType(identifier) else {
                return nil
            }
            guard let image = info[.originalImage] as? UIImage else {
                return nil
            }
            guard let data = image.jpegData(compressionQuality: 1) else {
                return nil
            }
            
            return (data: data, type: type)
        }
        .receive(on: DispatchQueue.main)
        .sink { [picked, presentationMode] output in
            picked(output)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
}
#endif

#if os(iOS) && DEBUG
struct PhotoPickerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            PhotoPicker { _ in }
                .preferredColorScheme(.light)
            
            PhotoPicker { _ in }
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
