import SwiftUI

struct FileStateCopyingView: View {
    
    @ObservedObject var model: FileCopyingModel
    
    var body: some View {
        HStack {
            ProgressView(value: model.progress)
        }
    }
    
}
