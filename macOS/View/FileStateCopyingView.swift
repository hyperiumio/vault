import SwiftUI

struct FileStateCopyingView: View {
    
    @ObservedObject var model: FileStateCopyingModel
    
    var body: some View {
        return HStack {
            ProgressIndicator(value: model.progress)
        }
    }
    
}
