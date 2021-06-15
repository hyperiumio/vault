import SwiftUI

struct VaultItemFooter: View {
    
    private let created: Date?
    private let modified: Date?
    
    init(created: Date?, modified: Date?) {
        self.created = created
        self.modified = modified
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .custom, spacing: 4) {
                if let created = created {
                    DateLabel(.created, date: created)
                }

                if let modified = modified {
                    DateLabel(.modified, date: modified)
                }
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding()
            
            Spacer()
        }
    }
    
}

private struct DateLabel: View {
    
    private let text: LocalizedStringKey
    private let date: Date
    
    init(_ text: LocalizedStringKey, date: Date) {
        self.text = text
        self.date = date
    }
    
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(.semibold)
                .textCase(.uppercase)
                .alignmentGuide(.custom) { dimension in
                    dimension[HorizontalAlignment.trailing]
                }
               
            Text(date, formatter: Self.dateFormatter)
        }
    }
    
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
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
struct VaultItemFooterPreview: PreviewProvider {
    
    static var previews: some View {
        VaultItemFooter(created: .distantPast, modified: .distantFuture)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
