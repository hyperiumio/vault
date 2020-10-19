import SwiftUI
import Pasteboard

struct SecureItemDateDisplayField: View {
    
    private let title: String
    private let date: Date
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    init(_ title: String, date: Date) {
        self.title = title
        self.date = date
    }
    
    var body: some View {
        SecureItemButton {
            Pasteboard.general.string = formattedDate
        } content: {
            SecureItemDisplayField(title) {
                Text(formattedDate)
            }
        }
    }
    
}

struct SecureItemDateEditField: View {
    
    private let title: String
    private let date: Binding<Date>
    
    init(_ title: String, date: Binding<Date>) {
        self.title = title
        self.date = date
    }
    
    var body: some View {
        SecureItemView {
            SecureItemDisplayField(title) {
                HStack {
                    DatePicker(title, selection: date, displayedComponents: .date)
                        .labelsHidden()
                    
                    Spacer()
                }
            }
        }
    }
    
}
