import SwiftUI

#warning("Todo")
struct GeneratePasswordView: View {
    
    let passworGenerator: (String?) -> Void
    
    @StateObject private var model = GeneratePasswordModel()
    
    private var length: Binding<Double> {
        Binding<Double> {
            Double(model.length)
        } set: { length in
            let length = Int(length)
            guard model.length != length else { return }
            
            model.length = length
        }
    }
    
    init(passworGenerator: @escaping (String?) -> Void) {
        self.passworGenerator = passworGenerator
    }
    
    #if os(iOS)
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.password ?? "")
                .font(.password)
    //            .foregroundColor(.label)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(minHeight: TextStyle.title2.lineHeight)
            
            HStack() {
                Text(.localizedCharacters(model.length))
                
                Slider(value: length, in: 16 ... 64)
            }
            
            Toggle(.numbers, isOn: $model.digitsEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            
            Toggle(.symbols, isOn: $model.symbolsEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        }
        .font(.text)
 //       .foregroundColor(.secondaryLabel)
        .onChange(of: model.password, perform: passworGenerator)
        .onAppear {
       //     model.createPassword()
        }
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.password ?? "")
                .font(.password)
    //            .foregroundColor(.label)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(minHeight: TextStyle.title2.lineHeight)
            
            HStack() {
                Text(.localizedCharacters(model.length))
                
                Slider(value: length, in: 16 ... 64)
                    .alignmentGuide(.custom) { dimension in
                        dimension[HorizontalAlignment.leading]
                    }
            }
            
            HStack {
                Text(.numbers)
                
                Toggle(.numbers, isOn: $model.digitsEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .labelsHidden()
                    .alignmentGuide(.custom) { dimension in
                        dimension[HorizontalAlignment.leading]
                    }
            }
            
            HStack {
                Text(.symbols)
                
                Toggle(.symbols, isOn: $model.symbolsEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .labelsHidden()
                    .alignmentGuide(.custom) { dimension in
                        dimension[HorizontalAlignment.leading]
                    }
            }
        }
        .frame(maxWidth: 300)
        .font(.text)
  //      .foregroundColor(.secondaryLabel)
        .onChange(of: model.password, perform: passworGenerator)
        .onAppear {
    //        model.createPassword()
        }
    }
    #endif
    
}

#if os(macOS)
private typealias TextStyle = NSFont.TextStyle

private extension NSFont.TextStyle {
    
    var lineHeight: CGFloat {
        let font = NSFont.preferredFont(forTextStyle: self)
        return NSLayoutManager().defaultLineHeight(for: font)
    }
    
}
#endif
    
#if os(iOS)
private typealias TextStyle = UIFont.TextStyle

private extension UIFont.TextStyle {

    var lineHeight: CGFloat {
        UIFont.preferredFont(forTextStyle: self).lineHeight
    }
    
}
#endif

private extension Font {
    
    static var password: Self {
        .system(.body, design: .monospaced)
    }
    
    static var text: Self {
        Font.body.monospacedDigit()
    }
    
}

private extension HorizontalAlignment {
    
    struct CustomAlignment: AlignmentID {
        
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
        
    }

    static let custom = HorizontalAlignment(CustomAlignment.self)
}

#if DEBUG
struct GeneratePasswordViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            GeneratePasswordView { _ in }
                .preferredColorScheme(.light)
            
            GeneratePasswordView { _ in }
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
