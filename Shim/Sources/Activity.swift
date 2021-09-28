#if os(iOS)
import LinkPresentation
import SwiftUI

public struct Activity: UIViewControllerRepresentable {
    
    private let item: ItemSource
    private let excludedTypes: Set<UIActivity.ActivityType>
    
    public init(item: Any, title: String, activityTypes: UIActivity.ActivityType...) {
        self.item = ItemSource(item: item, title: title)
        self.excludedTypes = UIActivity.ActivityType.types.subtracting(activityTypes)
    }
    
    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityItems = [item]
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        controller.excludedActivityTypes = Array(excludedTypes)
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    
}

private extension UIActivity.ActivityType {
    
    static var types: Set<Self> {
        [
            .postToFacebook,
            .postToTwitter,
            .postToWeibo,
            .message,
            .mail,
            .print,
            .copyToPasteboard,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .airDrop,
            .openInIBooks,
            .markupAsPDF
        ]
    }
    
}

private extension Activity {
    
    class ItemSource: NSObject, UIActivityItemSource {
        
        private let item: Any
        private let title: String
        
        init(item: Any, title: String) {
            self.item = item
            self.title = title
        }
        
        func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
            item
        }
        
        func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
            item
        }
        
        func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
            let metadata = LPLinkMetadata()
            metadata.title = title
            return metadata
        }
        
    }
    
}
#endif
