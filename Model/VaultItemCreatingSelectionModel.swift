import Combine
import Crypto
import Foundation
import Store

protocol VaultItemCreatingSelectionModelRepresentable: ObservableObject, Identifiable {
    
    func createLogin()
    func createPassword()
    func createFile()
    func createNote()
    func createBankCard()
    func createWifi()
    func createBankAccount()
    func createCustomItem()
    
}

class VaultItemCreatingSelectionModel: VaultItemCreatingSelectionModelRepresentable {
    
    var event: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    
    func createLogin() {
        let event = Event.creationRequest(.login)
        eventSubject.send(event)
    }
    
    func createPassword() {
        let event = Event.creationRequest(.password)
        eventSubject.send(event)
    }
    
    func createFile() {
        let event = Event.creationRequest(.file)
        eventSubject.send(event)
    }
    
    func createNote() {
        let event = Event.creationRequest(.note)
        eventSubject.send(event)
    }
    
    func createBankCard() {
        let event = Event.creationRequest(.bankCard)
        eventSubject.send(event)
    }
    
    func createWifi() {
        let event = Event.creationRequest(.wifi)
        eventSubject.send(event)
    }
    
    func createBankAccount() {
        let event = Event.creationRequest(.bankAccount)
        eventSubject.send(event)
    }
    
    func createCustomItem() {
        let event = Event.creationRequest(.custom)
        eventSubject.send(event)
    }
    
}

extension VaultItemCreatingSelectionModel {
    
    enum Event {
        
        case creationRequest(SecureItem.TypeIdentifier)
        
    }
    
}
