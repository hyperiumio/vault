import SwiftUI

struct SecureItemDateDisplayField: View {
    
    private let title: String
    private let date: Date
    
    init(_ title: String, date: Date) {
        self.title = title
        self.date = date
    }
    
    var body: some View {
        SecureItemField(title) {
            Text(date, style: .date)
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
        SecureItemField(title) {
            DatePicker(title, selection: date)
                .labelsHidden()
        }
    }
    
}
