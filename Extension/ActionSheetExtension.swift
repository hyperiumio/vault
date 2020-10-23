import SwiftUI

extension ActionSheet {
    
    init(title: String, message: String? = nil, buttons: [ActionSheet.Button] = [.cancel()]) {
        let title = Text(title)
        let message = message.map(Text.init)
        
        self.init(title: title, message: message, buttons: buttons)
    }
    
}

extension ActionSheet.Button {
    
    static func `default`(_ label: String, action: (() -> Void)? = {}) -> Self {
        let label = Text(label)
        return Self.default(label, action: action)
    }
    
}
