import SwiftUI

struct CreateVaultItemButton: View {
    
    let action: (SecureItemType) -> Void
    
    @State private var isSheetVisible = false
    
    var body: some View {
        
        func showSheet() {
            isSheetVisible = true
        }
        
        return Button(action: showSheet) {
            return Image(systemName: "plus")
                .font(.title)
        }
        .actionSheet(isPresented: $isSheetVisible) {
            let title = Text(.chooseItemType)
            let buttons = [
                ActionSheet.Button.default(Text(.login)) {
                    self.action(.login)
                },
                ActionSheet.Button.default(Text(.password)) {
                    self.action(.password)
                },
                ActionSheet.Button.default(Text(.file)) {
                    self.action(.file)
                },
                ActionSheet.Button.default(Text(.note)) {
                    self.action(.note)
                },
                ActionSheet.Button.default(Text(.bankCard)) {
                    self.action(.bankCard)
                },
                ActionSheet.Button.default(Text(.wifi)) {
                    self.action(.wifi)
                },
                ActionSheet.Button.default(Text(.bankAccount)) {
                    self.action(.bankAccount)
                }
            ] as [ActionSheet.Button]
            return ActionSheet(title: title, buttons: buttons)
        }
    }
    
}
