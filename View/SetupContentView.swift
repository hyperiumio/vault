import SwiftUI

struct SetupContentView<Input>: View where Input: View {
    
    private let buttonEnabled: Bool
    private let action: () -> Void
    private let image: Image
    private let title: Text
    private let description: Text
    private let input: Input
    private let button: Text
    
    init(buttonEnabled: Bool, action: @escaping () -> Void, @ViewBuilder image: () -> Image, @ViewBuilder title: () -> Text, @ViewBuilder description: () -> Text, @ViewBuilder input: () -> Input,  @ViewBuilder button: () -> Text) {
        self.buttonEnabled = buttonEnabled
        self.action = action
        self.image = image()
        self.title = title()
        self.description = description()
        self.input = input()
        self.button = button()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 0) {
                image
                    .renderingMode(.template)
                    .foregroundColor(.accentColor)
                
                Spacer()
                    .frame(height: 40)
                
                title
                    .font(.title)
                    .fontWeight(.medium)
                
                Spacer()
                    .frame(height: 10)
                
                description
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
                .frame(height: 40)
            
            input
            
            Spacer()
            
            Spacer()
            
            Button(action: action) {
                button
                    .frame(maxWidth: 300)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .disabled(!buttonEnabled)
        }
        .multilineTextAlignment(.center)
    }
    
}
