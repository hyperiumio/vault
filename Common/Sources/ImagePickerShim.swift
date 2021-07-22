#if os(iOS)
import Combine
import PhotosUI
import SwiftUI

struct ImagePickerShim: UIViewControllerRepresentable {
    
    private let picked: (Output?) -> Void
    @Environment(\.presentationMode) private var presentationMode
    
    init(picked: @escaping (Output?) -> Void) {
        self.picked = picked
    }
    
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

extension ImagePickerShim {
    
    typealias Output = (data: Data, type: UTType)
    
    class Coordinator: NSObject {
        
        private let presentationMode: Binding<PresentationMode>
        private let picked: (Output?) -> Void
        private var didPickSubscription: AnyCancellable?
        
        init(presentationMode: Binding<PresentationMode>, picked: @escaping (Output?) -> Void) {
            self.presentationMode = presentationMode
            self.picked = picked
        }

    }
    
}

extension ImagePickerShim.Coordinator: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        didPickSubscription = Future<Data, Error> { promise in
            results.first?.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                let result = Result<Data, Error> {
                    guard let url = url else {
                        throw NSError()
                    }
                    
                    return try Data(contentsOf: url)
                }
                promise(result)
            }
        }
        .map { data in
            (data: data, type: UTType.image)
        }
        .replaceError(with: nil)
        .receive(on: DispatchQueue.main)
        .sink { [picked, presentationMode] output in
            picked(output)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
}
#endif
