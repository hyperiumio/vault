import SwiftUI

struct DateFooter: View {
    
    private let created: Date?
    private let modified: Date?
    
    init(created: Date?, modified: Date?) {
        self.created = created
        self.modified = modified
    }
    
    var body: some View {
        VStack(alignment: .title, spacing: 4) {
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
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
}

private extension DateFooter {
    
    struct DateLabel: View {
        
        private let textKey: LocalizedStringKey
        private let date: Date
        
        init(_ textKey: LocalizedStringKey, date: Date) {
            self.textKey = textKey
            self.date = date
        }
        
        var body: some View {
            HStack {
                Text(textKey)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .alignmentGuide(.title) { dimension in
                        dimension[HorizontalAlignment.trailing]
                    }
                   
                Text(date, format: Date.FormatStyle(date: .abbreviated))
            }
        }
        
    }
    
}

private extension HorizontalAlignment {
    
    struct TitleAlignment: AlignmentID {
        
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
        
    }

    static let title = Self(TitleAlignment.self)
    
}

#if DEBUG
struct DateFooterPreview: PreviewProvider {
    
    static var previews: some View {
        DateFooter(created: .distantPast, modified: .distantFuture)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        DateFooter(created: .distantPast, modified: .distantFuture)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
