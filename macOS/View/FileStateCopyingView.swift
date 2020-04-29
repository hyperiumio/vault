import SwiftUI

struct FileStateCopyingView: View {
    
    @ObservedObject var model: FileCopyingModel
    
    var body: some View {
        return HStack {
            ProgressIndicator(value: model.progress)
        }
    }
    
}
