import SwiftUI

struct Icon: View {
    
    let item: Item
    
    var body: some View {
        switch item {
        case .password:
            Image(systemName: "key.fill")
                .foregroundColor(Color.appGray)
        case .login:
            Image(systemName: "person.fill")
                .foregroundColor(Color.appBlue)
        case .file:
            Image(systemName: "paperclip")
                .foregroundColor(Color.appGray)
        case .note:
            Image(systemName: "note.text")
                .foregroundColor(Color.appYellow)
        case .bankCard:
            Image(systemName: "creditcard.fill")
                .foregroundColor(Color.appGreen)
        case .wifi:
            Image(systemName: "wifi")
                .foregroundColor(Color.appBlue)
        case .bankAccount:
            Image(systemName: "dollarsign.circle.fill")
                .foregroundColor(Color.appGreen)
        case .custom:
            Image(systemName: "scribble.variable")
                .foregroundColor(Color.appRed)
        case .touchID:
            Image(systemName: "touchid")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.accentColor)
        case .faceID:
            Image(systemName: "faceid")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.accentColor)
        case .warning:
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
        case .masterPassword:
            Image(systemName: "key.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
        case .hideSecret:
            Image(systemName: "eye.slash.fill")
        case .showSecret:
            Image(systemName: "eye.fill")
        case .plus:
            Image(systemName: "plus")
                .imageScale(.large)
                .foregroundColor(.accentColor)
        case .lock:
            Image(systemName: "lock.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }

    init(_ item: Item) {
        self.item = item
    }
    
}

extension Icon {
    
    enum Item {
        
        case login
        case password
        case file
        case note
        case bankCard
        case wifi
        case bankAccount
        case custom
        case touchID
        case faceID
        case warning
        case masterPassword
        case hideSecret
        case showSecret
        case plus
        case lock
        
    }
    
}

#if DEBUG
extension Icon.Item: CaseIterable, Identifiable {
    
    var id: Self { self }
    
}

struct IconPreviewProvider: PreviewProvider {
    
    static var previews: some View {
        HStack(spacing: 20) {
            ForEach(Icon.Item.allCases) { item in
                Icon(item)
            }
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        .padding()
    }
    
}
#endif
